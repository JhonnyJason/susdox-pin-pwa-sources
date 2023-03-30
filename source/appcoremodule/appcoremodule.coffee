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

############################################################
export initialize = ->
    log "initialize"
    S.addOnChangeListener("userCredentials", userCredentialsChanged)
    return

############################################################
#region internal Functions

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
    # content.setToLoginPage()
    content.setToDefault()
    return

export upgrade = ->
    log "upgrade"
    ##TODO
    return

userCredentialsChanged = ->
    log "userCredentialsChanged"
    credentials = S.load("userCredentials")
    olog credentials
    if credentials and Object.keys(credentials).length > 0 then login()
    return

############################################################
login = ->
    log "login"
    credentials = S.load("userCredentials")
    radiologistImages.loadImages()
    content.setToUserPage()
    
    ## Check for updates
    imageURLs = []
    try
        loginBody = utl.loginRequestBody(credentials)
        response = await sci.loginRequest(loginBody)
        log response 
        imageURLs = await sci.getImages(credentials)
    catch err 
        log err
        if err instanceof AuthenticationError then logout()
        return
    data.setRadiologistImages(imageURLs)
    return
    
############################################################
export startUp = ->
    log "startUp"

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



