############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as content from "./contentmodule.js"

############################################################
export initialize = ->
    log "initialize"
    susdoxLogo.addEventListener("click", susdoxLogoClicked)
    return

############################################################
susdoxLogoClicked = ->
    log "susdoxLogoClicked"
    content.setToDefault()
    return