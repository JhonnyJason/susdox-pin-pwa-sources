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
codeButton = document.getElementById("code-button")

############################################################
export initialize = ->
    log "initialize"
    addCodeButton.addEventListener("click", addCodeButtonClicked)
    acceptButton.addEventListener("click", acceptButtonClicked)
    codeButton.addEventListener("click", codeButtonClicked)
    return

############################################################
addCodeButtonClicked = (evnt) ->
    log "addCodeButtonClicked"
    # evnt.preventDefault()
    triggers.addCode()
    # return false
    return

############################################################
codeButtonClicked = (evnt) ->
    log "codeButtonClicked"
    # evnt.preventDefault()

    toReveal = !("coderevealed" == uiState.getModifier())
    if toReveal
        valid = await account.accountIsValid()
        log valid
        if !valid then return triggers.invalidCode()

    triggers.codeReveal(toReveal)
    # return false
    return

############################################################
export acceptButtonClicked = (evnt) ->
    log "acceptButtonClicked"
    # evnt.preventDefault()

    acceptButton.classList.add("disabled")
    currentBase = uiState.getBase()

    olog { currentBase }

    switch currentBase
        when "add-code", "update-code" 
            await credentialsFrame.acceptInput()
        when "request-code", "request-update-code" 
            await requestcodeFrame.requestCode()
    
    acceptButton.classList.remove("disabled")
    # return false
    alert("acceptButtonClicked finished!")
    return
