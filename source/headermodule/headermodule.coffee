############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as app from "./appcoremodule.js"

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
    app.triggerHome()
    return

menuButtonClicked = ->
    log "menuButtonClicked"
    app.triggerMenu()
    return

menuCloseButtonClicked = ->
    log "menuCloseButtonClicked"
    app.triggerMenu()
    return



