############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import * as credentialsframe from "./credentialsframemodule.js"
import * as radiologistImages from "./radiologistimagemodule.js"
import * as codeDisplay from "./codedisplaymodule.js"
import * as menuModule from "./menumodule.js"
import * as cubeModule from "./cubemodule.js"

############################################################
menuFrame = document.getElementById("menu-frame")

############################################################
currentState = "default"

############################################################
export initialize = ->
    log "initialize"
    menuFrame.addEventListener("click", menuFrameClicked)
    return

############################################################
menuFrameClicked = (evnt) ->
    log "menuFrameClicked"
    menuModule.setMenuOff()
    return

############################################################
export susdoxLogoClicked = ->
    if currentState == "login" then setToDefault()
    if currentState == "logged-in" then radiologistImages.setSustSolLogo()

############################################################
export setToDefault = ->
    log "setToDefault"
    currentState = "default"

    content.classList.remove("preload")
    content.classList.remove("setting-credentials")
    content.classList.remove("credentials-set")
    
    menuModule.setMenuOff()
    
    return

############################################################
export setToLoginPage = ->
    log "setToDefault"
    currentState = "login"

    content.classList.remove("preload")
    content.classList.remove("credentials-set")
    content.classList.add("setting-credentials")
    
    menuModule.setMenuOff()
    return

############################################################
export setToUserPage = ->
    log "setToUserPage"
    currentState = "logged-in"

    content.classList.remove("preload")
    content.classList.remove("setting-credentials")
    content.classList.add("credentials-set")
    
    cubeModule.allowTouch()

    menuModule.setMenuOff()    
    return