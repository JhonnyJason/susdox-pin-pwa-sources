############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("logoutmodal")
#endregion

############################################################
import M from "mustache"

############################################################
import { ModalCore } from "./modalcore.js"
import * as account from "./accountmodule.js"

############################################################
core = null

############################################################
messageTemplate = ""
messageElement = null

############################################################
export initialize =  ->
    log "initialize"
    core = new ModalCore(logoutmodal)
    core.connectDefaultElements()

    messageTemplate = logoutmodalContentMessageTemplate.innerHTML
    messageElement = logoutmodal.getElementsByClassName("modal-content")[0]
    return

############################################################
export userConfirmation = ->
    log "userConfirmation"
    return core.modalPromise


############################################################
export turnUpModal = ->
    log "turnUpModal"
    accountObj = account.getAccountObject()
    messageElement.innerHTML = M.render(messageTemplate, accountObj)

    core.activate()
    return

############################################################
export turnDownModal = (reason) ->
    log "turnDownModal"
    core.reject(reason)
    return