############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as trigger from "./navtriggers.js"

############################################################
export initialize = ->
    log "initialize"
    susdoxLogo.addEventListener("click", susdoxLogoClicked)
    menuButton.addEventListener("click", menuButtonClicked)
    menuCloseButton.addEventListener("click", menuCloseButtonClicked)
    return

############################################################
susdoxLogoClicked = ->
    log "susdoxLogoClicked"
    trigger.home()
    return

menuButtonClicked = ->
    log "menuButtonClicked"
    trigger.menu(on)
    return

menuCloseButtonClicked = ->
    log "menuCloseButtonClicked"
    trigger.menu(off)
    return



