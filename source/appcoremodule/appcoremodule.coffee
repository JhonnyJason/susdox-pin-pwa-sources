############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
#region Imported Modules
import * as S from "./statemodule.js"

############################################################
import * as nav from "./navmodule.js"
import * as account from "./accountmodule.js"

############################################################
import * as credentialsFrame from "./credentialsframemodule.js"
import * as mainButton from "./mainbuttonmodule.js"

import * as codeDisplay from "./codedisplaymodule.js"
import * as usernameDisplay from "./usernamedisplaymodule.js"
import * as menuModule from "./menumodule.js"

import * as radiologistImages from "./radiologistimagemodule.js"

############################################################
import * as verificationModal from "./codeverificationmodal.js"
import * as invalidcodeModal from "./invalidcodemodal.js"
import * as logoutModal from "./logoutmodal.js"

############################################################
import { AuthenticationError } from "./errormodule.js"
import { appVersion } from "./configmodule.js"

#endregion

############################################################
serviceWorker = null
if navigator? and navigator.serviceWorker? 
    serviceWorker = navigator.serviceWorker

############################################################
currentVersion = document.getElementById("current-version")
newVersion = document.getElementById("new-version")
menuVersion = document.getElementById("menu-version")

############################################################
appBaseState = "no-code"
appUIMod = "none"
urlCode = null

############################################################
checkedURLForCode = false
accountAvailable = false
startUpProcessed = false

############################################################
export initialize = ->
    log "initialize"

    currentVersion.textContent = appVersion
    
    if serviceWorker?
        serviceWorker.register("serviceworker.js", {scope: "/"})
        if serviceWorker.controller?
            serviceWorker.controller.postMessage("App is version: #{appVersion}!")
        serviceWorker.addEventListener("message", onServiceWorkerMessage)
        serviceWorker.addEventListener("controllerchange", onServiceWorkerSwitch)

    S.addOnChangeListener("navState", navStateChanged)
    S.addOnChangeListener("activeAccount", activeAccountChanged)
    return

############################################################
#region internal Functions

############################################################
#region Event Listeners

############################################################
navStateChanged = ->
    log "navStateChanged"
    {base, modifier} = S.get("navState")
    olog { base, modifier }
    
    # reset always
    accountToUpdate = null

    if !startUpProcessed then await startUp()

    modChanged = modifier != appUIMod

    ########################################
    # Apply States
    switch base
        when "RootState"
            if accountAvailable then setAppState("user-images", modifier) 
            else setAppState("no-code", modifier)
        when "AddCode" then setAppState("add-code", modifier)
    
    if modChanged then log "modChanged to #{modifier}"
    return unless modChanged

    switch modifier
        when "logoutconfirmation" then triggerLogout()
        when "invalidcode" then triggerCodeReveal()
    return

############################################################
activeAccountChanged = ->
    log "activeAccountChanged"
    await checkAccountAvailability()
    if accountAvailable then await triggerAccountLoginCheck()
    else # last account has been deleted
        setAppState("no-code")
        deleteImageCache()

    await triggerHome()
    updatePeriphery()
    return

#endregion

############################################################
startUp = ->
    log "startUp"
    ## Check if we got a code for a new Account
    urlCode = getCodeFromURL()
    if urlCode? then await triggerURLCodeDetected()
    
    await checkAccountAvailability()
    if accountAvailable then await triggerAccountLoginCheck()

    updatePeriphery()
    startUpProcessed = true
    return

############################################################
checkAccountAvailability = ->
    log "checkAccountAvailability"
    try 
        await account.getUserCredentials()
        accountAvailable = true
        return # return fast if we have an account
    catch err then log err
    
    # no account available
    accountAvailable = false
    return

############################################################
updatePeriphery = ->
    log "updatePeriphery"
    # update data in peripheral UIs
    menuModule.updateAllUsers()
    codeDisplay.updateCode()
    usernameDisplay.updateUsername()
    return

############################################################
setAppState = (base, mod) ->
    log "setAppState"
    if base then appBaseState = base
    if mod then appUIMod = mod
    log "#{appBaseState}:#{appUIMod}"
    S.set("uiState", "#{appBaseState}:#{appUIMod}")
    return

############################################################
getCodeFromURL = ->
    log "getCodeFromURL"
    # ##TODO remove: setting code for testing
    # code = "123123"
    # return code

    url = new URL(window.location)
    hash = url.hash

    history.replaceState(history.state, document.title, "/")
    if !hash then return null
    
    code = hash.replace("#", "")
    log code
    return code

############################################################
addValidAccount = (credentials) ->
    log "addValidAccount"
    # we set it as active by default
    accountIndex = account.addNewAccount(credentials)
    account.setAccountActive(accountIndex)
    account.setAccountValid(accountIndex)
    return
    
############################################################
onServiceWorkerMessage = (evnt) ->
    log("  !  onServiceWorkerMessage")
    if typeof evnt.data == "object" and evnt.data.version?
        serviceworkerVersion = evnt.data.version
        # olog { appVersion, serviceworkerVersion }
        if serviceworkerVersion == appVersion then return
        newVersion.textContent = serviceworkerVersion
        menuVersion.classList.add("to-update")
    return

onServiceWorkerSwitch = ->
    console.log("  !  onServiceWorkerSwitch")
    serviceWorker.controller.postMessage("Hello I am version: #{appVersion}!")
    serviceWorker.controller.postMessage("tellMeVersion")
    return

deleteImageCache = ->
    log "deleteImageCache"
    if serviceWorker? and serviceWorker.controller?
        serviceWorker.controller.postMessage("deleteImageCache")
    return
    
#endregion

############################################################
#region User Action Triggers

export triggerURLCodeDetected = ->
    log "triggerURLCodeDetected"
    try
        setAppState("", "codeverification")
        await nav.addModification("codeverification")
        credentials = await verificationModal.pickUpConfirmedCredentials(urlCode)
        addValidAccount(credentials)
    catch err then log err
    finally await nav.unmodify()
    return

############################################################
export triggerAccountLoginCheck = ->
    log "triggerAccountLoginCheck"
    setAppState("pre-user-images", "none")

    try
        valid = await account.accountIsValid()
        if valid then await account.updateImages()
    catch err then log err
    
    setAppState("user-images", "none")
    return

############################################################
export triggerHome = ->
    log "triggerHome"
    if appBaseState == "user-images" and appUIMod == "none"
        radiologistImages.setSustSolLogo()
    else await nav.backToRoot()
    return

############################################################
export triggerMenu = ->
    log "triggerMenu"
    if appUIMod == "menu"
        await nav.unmodify()
        return
    
    setAppState("", "menu")
    await nav.addModification("menu")
    return

############################################################
export triggerAddCode = ->
    log "triggerAddCodeButton"
    setAppState("add-code")
    await nav.addStateNavigation("AddCode")
    return

############################################################
export triggerAccept = ->
    log "triggerAccept"
    try
        if !credentialsFrame.makeAcceptable() then return
        credentialsFrame.resetAllErrorFeedback()
        credentials = await credentialsFrame.extractCredentials()
        accountToUpdate = credentialsFrame.getAccountToUpdate()

        if !accountToUpdate? then addValidAccount(credentials)
        else
            # we just updated an account - switch credentials and save
            accountToUpdate.userCredentials = credentials
            account.saveAllAccounts()
            await nav.unmodify()
    
    catch err
        log err
        credentialsFrame.errorFeedback(err)    
    return

############################################################
export triggerCodeReveal = ->
    log "triggerCodeReveal"
    if appUIMod == "coderevealed" then return await nav.unmodify()
    try
        valid = await account.accountIsValid()
        if !valid ## then await triggerInvalidCode()
            setAppState("user-images", "invalidcode")
            await nav.addModification("invalidcode")
            deleteCode = await invalidcodeModal.promptCodeDeletion()
            await nav.unmodify()
            
            if deleteCode
                account.deleteAccount()
                return

        setAppState("user-images", "coderevealed")
        await nav.addModification("coderevealed")
        
    catch err 
        log err
        switch err
            when "updateButtonClicked" then triggerCodeUpdate()
            when "click-catcher", "modal-cancel-button", "modal-close-button"
                setAppState("user-images", "coderevealed")
                await nav.addModification("coderevealed")
    return

# export triggerInvalidCode = ->
#     log "triggerInvalidCode"
#     ## TODO implement, maybe
#     return


############################################################
export triggerCodeUpdate = ->
    log "triggerCodeUpdate"
    setAppState("user-images", "updatecode")
    await nav.addModification("updatecode")
    # try await mainButton.waitToAccept()
    # catch err then log err
    # await nav.unmodify()
    return

############################################################
export triggerLogout = ->
    log "triggerLogout"
    try
        setAppState("", "logoutconfirmation")
        await nav.addModification("logoutconfirmation")
        await logoutModal.userConfirmation()
        account.deleteAccount()
    catch err then log err
    finally await nav.unmodify()
    return

############################################################
export triggerUpgrade = ->
    log "triggerUpgrade"
    location.reload()
    return


#endregion


