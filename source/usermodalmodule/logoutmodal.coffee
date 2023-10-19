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
#region Internal Variables
core = null

############################################################
messageTemplate = ""
messageElement = null

############################################################
promiseConsumed = false

#endregion

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
    core.activate() unless core.modalPromise?
    promiseConsumed = true
    return core.modalPromise

############################################################
#region UI State Manipulation

export turnUpModal = ->
    log "turnUpModal"
    return if core.modalPromise? # already up

    accountObj = account.getAccountObject()
    cObj = {}
    if accountObj.label == "" then cObj.label = unnamedText
    else cObj.label = accountObj.label

    messageElement.innerHTML = M.render(messageTemplate, cObj)
    promiseConsumed = false
    
    core.activate()
    return

export turnDownModal = (reason) ->
    log "turnDownModal"
    if core.modalPromise? and !promiseConsumed 
        core.modalPromise.catch(()->return)
        # core.modalPromise.catch((err) -> log("unconsumed: #{err}"))

    core.reject(reason)
    promiseConsumed = false
    return

#endregion