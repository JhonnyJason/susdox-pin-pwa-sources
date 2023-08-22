############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("usermodalmodule")
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
export initialize = ->
    log "initialize"
    core = new ModalCore(invalidcodemodal)
    core.connectDefaultElements()

    messageTemplate = invalidcodemodalContentMessageTemplate.innerHTML
    messageElement = invalidcodemodal.getElementsByClassName("modal-content")[0]
    return


############################################################
export promptCodeDeletion = ->
    log "promptCodeDeletion"
    accountObj = account.getAccountObject()
    messageElement.innerHTML = M.render(messageTemplate, accountObj)

    core.activate()
    return core.modalPromise