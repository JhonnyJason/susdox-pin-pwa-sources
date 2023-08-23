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
updateButton = document.getElementById("invalidcodemodal-update-button")

############################################################
export initialize = ->
    log "initialize"
    core = new ModalCore(invalidcodemodal)
    core.connectDefaultElements()

    messageTemplate = invalidcodemodalContentMessageTemplate.innerHTML
    messageElement = invalidcodemodal.getElementsByClassName("modal-content")[0]
    
    updateButton.addEventListener("click", updateButtonClicked)
    return

############################################################
updateButtonClicked = (evnt) ->
    log "updateButtonClicked"
    core.reject("updateButtonClicked")
    return

############################################################
export promptCodeDeletion = ->
    log "promptCodeDeletion"
    accountObj = account.getAccountObject()
    messageElement.innerHTML = M.render(messageTemplate, accountObj)

    core.activate()
    return core.modalPromise