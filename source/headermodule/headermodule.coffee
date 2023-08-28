############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as app from "./appcoremodule.js"

############################################################
export initialize = ->
    ## prod log "initialize"
    susdoxLogo.addEventListener("click", susdoxLogoClicked)
    menuButton.addEventListener("click", menuButtonClicked)
    menuCloseButton.addEventListener("click", menuCloseButtonClicked)
    return

############################################################
susdoxLogoClicked = ->
    ## prod log "susdoxLogoClicked"
    app.triggerHome()
    return

menuButtonClicked = ->
    ## prod log "menuButtonClicked"
    app.triggerMenu()
    return

menuCloseButtonClicked = ->
    ## prod log "menuCloseButtonClicked"
    app.triggerMenu()
    return



