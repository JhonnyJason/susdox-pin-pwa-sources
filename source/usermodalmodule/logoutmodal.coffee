############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("logoutmodal")
#endregion

############################################################
import { ModalCore } from "./modalcore.js"

############################################################
core = null

############################################################
export initialize =  ->
    log "initialize"
    core = new ModalCore(logoutmodal)
    core.connectDefaultElements()
    return

############################################################
export userConfirmation = ->
    log "userConfirmation"
    core.activate()
    return core.modalPromise