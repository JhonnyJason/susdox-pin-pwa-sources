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
unnamedTextElement = document.getElementById("unnamed-text-element")
unnamedText = unnamedTextElement.textContent

############################################################
core = null

############################################################
messageTemplate = ""
messageElement = null

promiseConsumed = false

############################################################
export initialize =  ->
    ## prod log "initialize"
    core = new ModalCore(logoutmodal)
    core.connectDefaultElements()

    messageTemplate = logoutmodalContentMessageTemplate.innerHTML
    messageElement = logoutmodal.getElementsByClassName("modal-content")[0]
    return

############################################################
export userConfirmation = ->
    ## prod log "userConfirmation"
    promiseConsumed = true
    return core.modalPromise


############################################################
export turnUpModal = ->
    ## prod log "turnUpModal"
    accountObj = account.getAccountObject()
    cObj = {}
    if accountObj.label == "" then cObj.label = unnamedText
    else cObj.label = accountObj.label

    messageElement.innerHTML = M.render(messageTemplate, cObj)
    promiseConsumed = false
    
    core.activate()
    return

############################################################
export turnDownModal = (reason) ->
    ## prod log "turnDownModal"
    if core.modalPromise? and !promiseConsumed 
        core.modalPromise.catch(()->return)
        # core.modalPromise.catch((err) -> log("unconsumed: #{err}"))

    core.reject(reason)
    return