############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import * as content from "./contentmodule.js"
import * as data from "./datamodule.js"
import * as account from "./accountmodule.js"
import * as cubeModule from "./cubemodule.js"
import * as radiologistImages from "./radiologistimagemodule.js"
import * as sci from "./scimodule.js"
import * as utl from "./utilmodule.js"
import * as confirmPopup from "./confirmationpopupmodule.js"
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
            serviceWorker.controller.postMessage("Hello I am version: #{appVersion}!")
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
            credentials = await confirmPopup.pickUpConfirmedCredentials(code)
            # log "We could pick up some credentials ;-)"
            olog {credentials}

            # the new account is valid and we set it as active by default
            accountIndex = account.addNewAccount(credentials)
            account.setAccountActive(accountIndex)
            account.setAccountValid(accountIndex)

        catch err then log err

    try enterUserPage()
    catch err then content.setToDefault()
    # if credentials and Object.keys(credentials).length > 0 then login()
    # else content.setToDefault()
    return


############################################################
#region internal Functions

############################################################
activeAccountChanged = ->
    log "activeAccountChanged"
    try 
      credentials = account.getUserCredentials()
    #   applyUserChange... 
      return
    catch err then log err
    # credentials = S.load("userCredentials")
    # olog credentials
    # if credentials and Object.keys(credentials).length > 0 then login()
    return

############################################################
getCodeFromURL = ->
    log "getCodeFromURL"
    url = new URL(window.location)
    hash = url.hash

    window.history.replaceState({}, document.title, "/")
    if !hash then return null
    
    code = hash.replace("#", "")
    log code
    return code

############################################################
enterUserPage = ->
    log "enterUserPage"
    credentials = account.getUserCredentials()
    # radiologistImages.loadImages()
    content.setToUserPage()
    
    # ## Check for updates
    # # imageURLs = ["img/karner-logo.jpg"] #TODO remove - just for testing
    # try
    #     # TODO uncomment - just for testing
    #     loginBody = utl.loginRequestBody(credentials)
    #     response = await sci.loginRequest(loginBody)
    #     log response 
    #     imageURLs = await sci.getImages(credentials)
    # catch err
    #     log err
    #     if err instanceof AuthenticationError then logout()
    # data.setRadiologistImages(imageURLs)
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
    ## TODO update to new Login/Logout flow

    cubeModule.reset()
    radiologistImages.reset()
    data.removeData()
    deleteImageCache()
    # content.setToLoginPage()
    content.setToDefault()
    return

export upgrade = ->
    log "upgrade"
    location.reload()
    return




