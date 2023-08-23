############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
import * as S from "./statemodule.js"
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
export initialize = ->
    log "initialize"

    currentVersion.textContent = appVersion
    
    if serviceWorker? 
        serviceWorker.register("serviceworker.js", {scope: "/"})
        if serviceWorker.controller?
            serviceWorker.controller.postMessage("App is version: #{appVersion}!")
        serviceWorker.addEventListener("message", onServiceWorkerMessage)
        serviceWorker.addEventListener("controllerchange", onServiceWorkerSwitch)
    
    S.addOnChangeListener("activeAccount", activeAccountChanged)
    return

############################################################
export startUp = ->
    log "startUp"
    ## Check if we got a code for a new Account
    code = getCodeFromURL()
    if code?
        try
            credentials = await verificationModal.pickUpConfirmedCredentials(code)
            # log "We could pick up some credentials ;-)"
            olog {credentials}

            # the new account is valid and we set it as active by default
            accountIndex = account.addNewAccount(credentials)
            account.setAccountActive(accountIndex)
            account.setAccountValid(accountIndex)

        catch err then log err

    activeAccountChanged()
    return

############################################################
#region internal Functions

############################################################
activeAccountChanged = ->
    log "activeAccountChanged"
    try await enterUserImagesState()
    catch err 
        deleteImageCache()
        content.setToDefaultState()

    menuModule.updateAllUsers()
    codeDisplay.updateCode()
    usernameDisplay.updateUsername()
    return

############################################################
getCodeFromURL = ->
    log "getCodeFromURL"
    # ##TODO remove: setting code for testing
    # code = "123123"
    # return code

    url = new URL(window.location)
    hash = url.hash

    window.history.replaceState({}, document.title, "/")
    if !hash then return null
    
    code = hash.replace("#", "")
    log code
    return code

############################################################
enterUserImagesState = ->
    log "enterUserImagesState"
    credentials = account.getUserCredentials()
    content.setToPreUserImagesState()
    
    valid = true

    try
        valid = await account.accountIsValid()
        if valid then await account.updateImages()
    catch err then log err
    
    content.setToUserImagesState()    
    return
    
    # # if !valid 
    # try
    #     await accountInvalidModal.userConfirm()
    #     account.deleteAccount()
    #     await enterUserImagesState()
    # catch err then log "User rejected account deletion!"
    return

############################################################
onServiceWorkerMessage = (evnt) ->
    log("  !  onServiceWorkerMessage")
    if typeof evnt.data == "object" and evnt.data.version?
        serviceworkerVersion = evnt.data.version
        olog { appVersion, serviceworkerVersion }
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
export moreInfo = ->
    log "moreInfo"
    ##TODO
    return

export logout = ->
    log "logout"
    account.deleteAccount()
    return

export upgrade = ->
    log "upgrade"
    location.reload()
    return

############################################################
export updateCode = ->
    log "updateCode"
    credentialsFrame.prepareForCodeUpdate()
    content.setToAddCodeState()
    try 
        await mainButton.waitToAccept()
    catch err
        log err
    ##TODO what do do more?
    content.setToUserImagesState()
    return





