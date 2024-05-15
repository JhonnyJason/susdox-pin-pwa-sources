############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("centerbuttonmodule")
#endregion

############################################################
import * as triggers from "./navtriggers.js"

############################################################
export initialize = ->
    log "initialize"
    centerbutton.addEventListener("click", centerButtonClicked)
    return

############################################################
centerButtonClicked = (evnt) ->
    log "centerButtonClicked"
    evnt.preventDefault()
    triggers.screeningsList()
    return