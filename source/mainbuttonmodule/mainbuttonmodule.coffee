############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("mainbuttonmodule")
#endregion

############################################################
import * as triggers from "./navtriggers.js"
import * as account from "./accountmodule.js"
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
    if toReveal
        valid = await account.accountIsValid()
        log valid
        if !valid then return triggers.invalidCode()

    triggers.codeReveal(toReveal)
    return

############################################################
requestCodeButtonClicked = (evnt) ->
    log "requestCodeButtonClicked"
    currentBase = uiState.getBase()
    if currentBase == "add-code" then triggers.requestCode()
    if currentBase == "update-code" then triggers.requestUpdateCode()
    return

############################################################
export acceptButtonClicked = (evnt) ->
    log "acceptButtonClicked"
    acceptButton.classList.add("disabled")
    currentBase = uiState.getBase()

    switch currentBase
        when "add-code", "update-code" 
            await credentialsFrame.acceptInput()
        when "request-code", "request-update-code" 
            await requestcodeFrame.requestCode()
    
    acceptButton.classList.remove("disabled")
    return
