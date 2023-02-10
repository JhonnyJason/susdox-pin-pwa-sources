############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import * as content from "./contentmodule.js"
import * as data from "./datamodule.js"

############################################################

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

############################################################
#region internal Functions

############################################################
getTokenFromURL = ->
    log "getTokenFromURL"
    urlParams = window.location.search
    ## TODO uncomment for production - for now we always want to act as if we have a URL param
    # if !urlParams then return
    # log "We had some URL Params:"
    # olog {urlParams}
    ## TODO extract one-time key from url params
    token = "a34b549f7bc29e6beaa1f0e59c2531d6318145d784e034e7a2878ff50763de90"
    return token

############################################################
pickUpCredentials = (token) ->
    log "pickUpCredentials"
    ## TODO
    uuid = "bf8603c5-7435-44d4-b1d0-22a5f67441c8"
    code = "23456789a"
    dateOfBirth = ""
    return { uuid, code, dateOfBirth }

#endregion

############################################################
export moreInfo = ->
    log "moreInfo"
    ##TODO
    return

export logout = ->
    log "logout"
    data.removeData()
    content.setToDefault()
    return

export upgrade = ->
    log "upgrade"
    ##TODO
    return

############################################################
export startUp = ->
    log "startUp"

    ## Check if we got some parameters to login automatically
    token = getTokenFromURL()
    if token? 
        credentials = await pickUpCredentials(token)
        log "We could pick up some credentials ;-)"
        olog {credentials}
        data.setUserCredentials(credentials)
        content.setToUserPage()        
        return

    content.setToDefault()
    return



