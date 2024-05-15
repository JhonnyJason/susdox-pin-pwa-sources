############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("mainbuttonmodule")
#endregion

############################################################
import * as triggers from "./navtriggers.js"
import * as credentialsFrame from "./credentialsframemodule.js"
import * as requestcodeFrame from "./requestcodeframemodule.js"
import * as uiState from "./uistatemodule.js"

############################################################
addCodeButton = document.getElementById("add-code-button")
acceptButton = document.getElementById("accept-button")
requestCodeButton = document.getElementById("request-code-button")
codeButton = document.getElementById("code-button")

############################################################
export initialize = ->
    log "initialize"
    addCodeButton.addEventListener("click", addCodeButtonClicked)
    acceptButton.addEventListener("click", acceptButtonClicked)
    requestCodeButton.addEventListener("click", requestCodeButtonClicked)
    codeButton.addEventListener("click", codeButtonClicked)
    return

############################################################
addCodeButtonClicked = (evnt) ->
    log "addCodeButtonClicked"
    triggers.addCode()
    return

############################################################
codeButtonClicked = (evnt) ->
    log "codeButtonClicked"
    toReveal = !("coderevealed" == uiState.getModifier()) 
    triggers.codeReveal(toReveal)
    return

############################################################
requestCodeButtonClicked = (evnt) ->
    log "requestCodeButtonClicked"
    triggers.requestCode()
    return

############################################################
export acceptButtonClicked = (evnt) ->
    log "acceptButtonClicked"
    acceptButton.classList.add("disabled")

    if "add-code" == uiState.getBase()
        await credentialsFrame.acceptInput()
    if "request-code" == uiState.getBase()
        await requestcodeFrame.requestCode()
    
    acceptButton.classList.remove("disabled")
    return
