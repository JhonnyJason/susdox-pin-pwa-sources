############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import * as S from "./statemodule.js"

############################################################
userCredentials = null
radiologistImages = null

############################################################
export initialize = ->
    log "initialize"
    userCredentials = S.load("userCredentials")
    radiologistImages = S.load("radiologistImages")
    olog { userCredentials, radiologistImages }
    return

############################################################
export setUserCredentials = (credentials) ->
    log "setUserCredentials"
    userCredentials = credentials
    S.save("userCredentials", userCredentials)
    return

export setRadiologistImages = (imageURLs) ->
    log "setRadiologistImages"
    return unless typeof imageURLs == "object"

    if Array.isArray(imageURLs) then radiologistImages = imageURLs
    else radiologistImages = Object.values(imageURLs)

    S.save("radiologistImages", radiologistImages)
    return

############################################################
export removeData = ->
    log "removeData"
    S.remove("userCredentials")
    S.remove("radiologistImages")

    userCredentials = S.load("userCredentials")
    radiologistImages = S.load("radiologistImages")
    olog { userCredentials, radiologistImages }
    return



