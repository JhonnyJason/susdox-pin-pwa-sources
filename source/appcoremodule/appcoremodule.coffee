############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import * as content from "./contentmodule.js"
import * as data from "./datamodule.js"
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
    
    S.addOnChangeListener("userCredentials", userCredentialsChanged)
    return

############################################################
#region internal Functions

############################################################
userCredentialsChanged = ->
    log "userCredentialsChanged"
    credentials = S.load("userCredentials")
    olog credentials
    if credentials and Object.keys(credentials).length > 0 then login()
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
login = ->
    log "login"
    credentials = S.load("userCredentials")
    radiologistImages.loadImages()
    content.setToUserPage()
    
    ## Check for updates
    imageURLs = ["img/karner-logo.jpg"] #TODO remove - just for testing
    try
        # TODO uncomment - just for testing
        # loginBody = utl.loginRequestBody(credentials)
        # response = await sci.loginRequest(loginBody)
        # log response 
        imageURLs = await sci.getImages(credentials)
    catch err
        log err
        if err instanceof AuthenticationError then logout()
    data.setRadiologistImages(imageURLs)
    return

############################################################
onServiceWorkerMessage = (evnt) ->
    console.log("  !  onServiceWorkerMessage")
    console.log("#{evnt.data}")

    if typeof evnt.data == "object" and evnt.data.version?
        newVersion.textContent = evnt.data.version
        menuVersion.classList.add("to-update")
        menuVersion.onclick = -> location.reload()
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
    cubeModule.reset()
    radiologistImages.reset()
    data.removeData()
    deleteImageCache()
    # content.setToLoginPage()
    content.setToDefault()
    return

export upgrade = ->
    log "upgrade"
    ##TODO
    return

############################################################
export startUp = ->
    log "startUp"
    ## TODO remove - just for testing
    login()
    return

    ## Check if we got some parameters to login automatically
    code = getCodeFromURL()
    if code?
        try
            credentials = await confirmPopup.pickUpConfirmedCredentials(code)
            # log "We could pick up some credentials ;-)"
            olog {credentials}
            data.removeData()
            data.setUserCredentials(credentials)
            return
        catch err then log err

    credentials = S.load("userCredentials")
    if credentials and Object.keys(credentials).length > 0 then login()
    else content.setToDefault()
    return



