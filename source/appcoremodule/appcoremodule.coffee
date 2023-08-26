############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import * as nav from "./navmodule.js"
import * as content from "./contentmodule.js"
import * as account from "./accountmodule.js"
import * as cubeModule from "./cubemodule.js"
import * as radiologistImages from "./radiologistimagemodule.js"
import * as codeDisplay from "./codedisplaymodule.js"
import * as usernameDisplay from "./usernamedisplaymodule.js"
import * as sci from "./scimodule.js"
import * as utl from "./utilmodule.js"
import * as verificationModal from "./codeverificationmodal.js"
import * as invalidcodeModal from "./invalidcodemodal.js"
import * as menuModule from "./menumodule.js"
import * as credentialsFrame from "./credentialsframemodule.js"
import * as mainButton from "./mainbuttonmodule.js"
import { AuthenticationError } from "./errormodule.js"
import { appVersion } from "./configmodule.js"

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
    S.addOnChangeListener("activeAccount", checkAccounts)
    return

############################################################
export startUp = ->
    log "startUp"
    ## Check if we got a code for a new Account
    urlCode = getCodeFromURL()
    if urlCode? then await triggerURLCodeDetected()

    checkAccounts()
    return

############################################################
#region internal Functions

############################################################
checkAccounts = ->
    # this function is called
    # - on startUp
    # - after user-switch
    # - after user-logout
    log "checkAccounts"
    try 
        await account.getUserCredentials()
        await tiggerAvailableAccount()
    catch err then appBaseState = "no-code"


    if appBaseState == "no-code" then deleteImageCache()
    S.set("uiState", "#{appBaseState}:none")

    menuModule.updateAllUsers()
    codeDisplay.updateCode()
    usernameDisplay.updateUsername()
    return

############################################################
navStateChanged = ->
    log "navStateChanged"
    ## TODO implement
    return

############################################################
setAppState = (base, mod) ->
    log "setAppState"
    if base then appBaseState = base
    if mod then appUIMod = mod
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
        await nav.addModification("codeverification")
        setAppState("", "codeverification")
        credentials = await verificationModal.pickUpConfirmedCredentials(urlCode)
        addValidAccount(credentials)
    catch err then log err
    finally await nav.unmodify()
    return

export triggerHome = ->
    log "triggerHome"
    await nav.backToRoot()
    return

export triggerMenu = ->
    log "triggerMenu"
    if appUIMod == "menu" then return await nav.unmodify()
    
    await nav.addModification("menu")
    setAppState("", "menu")
    return

export triggerAddCode = ->
    log "triggerAddCodeButton"
    ## TODO implement
    contentModule.setToAddCodeState()

    return

export triggerAccept = ->
    log "triggerAcceptButton"
    ## TODO implement
    
    return

export triggerAvailableAccount = ->
    log "triggerAvailableAccount"
    setAppState("pre-user-images", "none")

    try
        valid = await account.accountIsValid()
        if valid then await account.updateImages()
    catch err then log err
    
    setAppState("user-images", "none")
    return

export triggerLogout = ->
    log "triggerLogout"
    ## TODO reimplement
    try
        await logoutmodal.userConfirmation()
        log "LogoutModal.userConfirmation() succeeded!"
        account.deleteAccount()
    catch err then log err

    return

export triggerUpgrade = ->
    log "triggerUpgrade"
    location.reload()
    return


############################################################
export updateCode = ->
    log "updateCode"
    ## TODO rename and reimplement
    credentialsFrame.prepareForCodeUpdate()
    content.setToAddCodeState()
    try 
        await mainButton.waitToAccept()
    catch err
        log err
    ##TODO what do do more?
    content.setToUserImagesState()
    return


#endregion


