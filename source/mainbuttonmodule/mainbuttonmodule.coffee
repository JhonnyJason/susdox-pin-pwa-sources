############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("mainbuttonmodule")
#endregion

############################################################
import * as app from "./appcoremodule.js"
import * as credentialsframe from "./credentialsframemodule.js"
import * as contentModule from "./contentmodule.js"

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
    app.triggerAddCode()
    return

############################################################
codeButtonClicked = (evnt) ->
    log "codeButtonClicked"
    app.triggerCodeReveal()
    return

############################################################
export acceptButtonClicked = (evnt) ->
    log "acceptButtonClicked"
    acceptButton.classList.add("disabled")
    await app.triggerAccept()
    acceptButton.classList.remove("disabled")
    return
