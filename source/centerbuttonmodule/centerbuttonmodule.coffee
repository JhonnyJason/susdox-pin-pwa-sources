############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("centerbuttonmodule")
#endregion

############################################################
import * as uiState from "./uistatemodule.js"
import * as triggers from "./navtriggers.js"

requestCodeButton = document.getElementById("request-code-button")

############################################################
export initialize = ->
    log "initialize"
    centerbutton.addEventListener("click", centerButtonClicked)
    requestCodeButton.addEventListener("click", requestCodeButtonClicked)
    return

############################################################
centerButtonClicked = (evnt) ->
    log "centerButtonClicked"
    evnt.preventDefault()
    triggers.screeningsList()
    return

############################################################
requestCodeButtonClicked = (evnt) ->
    log "requestCodeButtonClicked"
    currentBase = uiState.getBase()
    if currentBase == "add-code" then triggers.requestCode()
    if currentBase == "update-code" then triggers.requestUpdateCode()
    return
