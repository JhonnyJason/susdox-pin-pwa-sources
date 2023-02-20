############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as content from "./contentmodule.js"
import * as menuModule from "./menumodule.js"

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
    content.susdoxLogoClicked()
    return

menuButtonClicked = ->
    log "menuButtonClicked"
    menuModule.setMenuOn()
    return

menuCloseButtonClicked = ->
    log "menuCloseButtonClicked"
    menuModule.setMenuOff()
    return



