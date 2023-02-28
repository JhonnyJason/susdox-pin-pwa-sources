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

############################################################
export initialize = ->
    log "initialize"
    S.addOnChangeListener("userCredentials", userCredentialsChanged)
    return

############################################################
#region internal Functions

############################################################
getTokenFromURL = ->
    log "getTokenFromURL"
    urlParams = window.location.search
    olog {urlParams}
    if !urlParams then return null
    urlParams = new URLSearchParams(urlParams)

    # log "We had some URL Params:"
    # olog {urlParams}
    ## TODO extract one-time key from url params
    # token = "a34b549f7bc29e6beaa1f0e59c2531d6318145d784e034e7a2878ff50763de90"
    return urlParams.get("token")

############################################################
pickUpCredentials = (token) ->
    log "pickUpCredentials"
    return await sci.getCredentials(token)

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
    content.setToLoginPage()
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
    imagesURLs = []
    try
        imageURLs = await sci.getImages(credentials.uuid)
    catch err then log err
    data.setRadiologistImages(imageURLs)
    return
    
############################################################
export startUp = ->
    log "startUp"

    ## Check if we got some parameters to login automatically
    token = getTokenFromURL()
    if token? 
        try
            credentials = await pickUpCredentials(token)
            log "We could pick up some credentials ;-)"
            olog {credentials}
            data.removeData()
            data.setUserCredentials(credentials)
            return
        catch err then log err


    credentials = S.load("userCredentials")
    if credentials and Object.keys(credentials).length > 0 then login()
    else content.setToDefault()
    return



