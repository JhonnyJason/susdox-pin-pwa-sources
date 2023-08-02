############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("usermodalmodule")
#endregion

############################################################
import { ModalCore } from "./modalcore.js"

############################################################
core = null

############################################################
export initialize = ->
    log "initialize"
    core = new ModalCore(invalidcodemodal)
    core.connectDefaultElements()
    return


############################################################
export promptCodeDeletion = ->
    log "promptCodeDeletion"
    core.activate()
    return core.modalPromise