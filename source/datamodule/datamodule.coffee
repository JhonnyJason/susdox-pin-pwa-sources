############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import * as S from "./statemodule.js"

############################################################
userCredentials = null

############################################################
export initialize = ->
    log "initialize"
    userCredentials = S.load("userCredentials")
    olog { userCredentials }
    return

############################################################
export setUserCredentials = (credentials) ->
    log "setUserCredentials"
    userCredentials = credentials
    S.save("userCredentials", userCredentials)
    return

export removeData = ->
    log "removeData"
    S.remove("userCredentials")
    ##TODO check what else to remove
    userCredentials = S.load("userCredentials")
    olog { userCredentials }
    return


