############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("centerbuttonmodule")
#endregion

############################################################
import * as app from "./appcoremodule.js"

############################################################
export initialize = ->
    ## prod log "initialize"
    centerbutton.addEventListener("click", centerButtonClicked)
    return

############################################################
centerButtonClicked = (evnt) ->
    ## prod log "centerButtonClicked"
    evnt.preventDefault()
    app.triggerScreeningList()
    return