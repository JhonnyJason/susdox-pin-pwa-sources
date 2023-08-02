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
    if currentState == "login" then setToDefaultState()
    if currentState == "logged-in" then radiologistImages.setSustSolLogo()

############################################################
#region State Setter Functions
export setToDefaultState = ->
    log "setToDefaultState"
    currentState = "default"

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    
    menuModule.setMenuOff()
    
    return

############################################################
export setToAddCodeState = ->
    log "setToAddCodeState"
    currentState = "login"

    content.classList.remove("preload")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.add("add-code")
    
    menuModule.setMenuOff()
    return

############################################################
export setToPreUserImagesState = ->
    log "setToPreUserImagesState"
    currentState = ""

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.add("pre-user-images")
    content.classList.remove("user-images")
    
    cubeModule.reset()

    menuModule.setMenuOff()    
    return

############################################################
export setToUserImagesState = ->
    log "setToUserImagesState"
    currentState = "logged-in"

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.add("user-images")
    
    cubeModule.allowTouch()

    menuModule.setMenuOff()    
    return

#endregion