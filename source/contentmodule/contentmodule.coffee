############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as account from "./accountmodule.js"
import * as utl from "./utilmodule.js"
import * as credentialsframe from "./credentialsframemodule.js"
import * as radiologistImages from "./radiologistimagemodule.js"
import * as codeDisplay from "./codedisplaymodule.js"
import * as menuModule from "./menumodule.js"
import * as cubeModule from "./cubemodule.js"

############################################################

############################################################
currentState = "default"

############################################################
export susdoxLogoClicked = ->
    log "susdoxLogoClicked"
    # switch currentState
    
    if currentState == "add-code"
        try 
            account.getUserCredentials()
            setToUserImagesState()
        catch err then setToDefaultState()
    
    if currentState == "user-images" 
        radiologistImages.setSustSolLogo()
    return

############################################################
#region State Setter Functions
export setToDefaultState = ->
    log "setToDefaultState"
    currentState = "default"

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")

    cubeModule.reset()
    radiologistImages.reset()
    credentialsframe.resetAllErrorFeedback()

    menuModule.setMenuOff()    
    return

############################################################
export setToAddCodeState = ->
    log "setToAddCodeState"
    currentState = "add-code"

    content.classList.remove("preload")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.add("add-code")

    cubeModule.reset()
    radiologistImages.reset()
    credentialsframe.resetAllErrorFeedback()

    menuModule.setMenuOff()
    return

############################################################
export setToPreUserImagesState = ->
    log "setToPreUserImagesState"
    currentState = "pre-user-images"

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.add("pre-user-images")
    content.classList.remove("user-images")
    
    cubeModule.reset()
    radiologistImages.reset()
    credentialsframe.resetAllErrorFeedback()

    menuModule.setMenuOff()    
    return

############################################################
export setToUserImagesState = ->
    log "setToUserImagesState"
    credentialsframe.resetAllErrorFeedback()
    radiologistImages.loadImages()

    currentState = "user-images"

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.add("user-images")
    
    cubeModule.allowTouch()

    menuModule.setMenuOff()    
    return

#endregion
