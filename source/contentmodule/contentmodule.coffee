############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as radiologistImages from "./radiologistdatamodule.js"
import * as codeDisplay from "./codedisplaymodule.js"
import * as cubeModule from "./cubemodule.js"
import * as screeningsList from "./screeningslistmodule.js"
import * as credentialsFrame from "./credentialsframemodule.js"
import * as requestFrame from "./requestcodeframemodule.js"

############################################################
#region State Setter Functions
export setToDefaultState = ->
    log "setToDefaultState"
    # await cubeModule.waitForTransition()
    codeDisplay.hideCode()
    cubeModule.reset()
    radiologistImages.reset()
    screeningsList.hide()
    requestFrame.reset()
    credentialsFrame.reset()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.remove("code-revealed")
    content.classList.remove("request-code")
    return

############################################################
export setToAddCodeState = ->
    log "setToAddCodeState"
    # await cubeModule.waitForTransition()
    codeDisplay.hideCode()
    cubeModule.reset()
    radiologistImages.reset()
    screeningsList.hide()
    # requestFrame.reset()
    credentialsFrame.prepareForAddCode()

    content.classList.remove("preload")
    content.classList.add("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.remove("code-revealed")
    content.classList.remove("request-code")
    return

############################################################
export setToUpdateCodeState = ->
    log "setToUpdateCodeState"
    # await cubeModule.waitForTransition()
    codeDisplay.hideCode()
    cubeModule.reset()
    radiologistImages.reset()
    screeningsList.hide()
    # requestFrame.reset()
    credentialsFrame.prepareForCodeUpdate()

    content.classList.remove("preload")
    content.classList.add("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.remove("code-revealed")
    content.classList.remove("request-code")
    return

############################################################
export setToRequestCodeState = ->
    log "setToRequestCodeState"
    # await cubeModule.waitForTransition()
    codeDisplay.hideCode()
    screeningsList.hide()
    cubeModule.reset()
    cubeModule.setRequestCodeFrame() # must be before requestFrame.prepareForRequest, otherwise the Frame is not in the DOM
    radiologistImages.reset()
    # credentialsFrame.reset() ## no need to reset here!
    requestFrame.prepareForRequest()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.remove("code-revealed")
    content.classList.add("request-code")
    return

############################################################
export setToRequestUpdateCodeState = ->
    log "setToRequestUpdateCodeState"
    # await cubeModule.waitForTransition()
    codeDisplay.hideCode()
    screeningsList.hide()
    cubeModule.reset()
    cubeModule.setRequestCodeFrame() # must be before requestFrame.prepareForRequest, otherwise the Frame is not in the DOM
    radiologistImages.reset()
    # credentialsFrame.reset() ## no need to reset here!
    requestFrame.prepareForUpdateRequest()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.remove("code-revealed")
    content.classList.add("request-code")
    return

############################################################
export setToPreUserImagesState = ->
    log "setToPreUserImagesState"
    # await cubeModule.waitForTransition()
    codeDisplay.hideCode()
    screeningsList.hide()
    cubeModule.reset()
    cubeModule.setPreUserImages()
    radiologistImages.reset()
    credentialsFrame.reset()
    requestFrame.reset()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.add("pre-user-images")
    content.classList.remove("user-images")
    content.classList.remove("code-revealed")
    content.classList.remove("request-code")    
    return

############################################################
export setToUserImagesState = ->
    log "setToUserImagesState"
    await cubeModule.waitForTransition()
    codeDisplay.hideCode()
    screeningsList.hide()
    cubeModule.allowTouch()
    radiologistImages.loadData()
    credentialsFrame.reset()
    requestFrame.reset()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.add("user-images")
    content.classList.remove("code-revealed")
    content.classList.remove("request-code")    
    return

export setToCodeRevealedState = ->
    
    await cubeModule.waitForTransition()
    codeDisplay.revealCode()
    screeningsList.hide()
    cubeModule.setCodeRevealed()
    radiologistImages.loadData()
    credentialsFrame.reset()
    requestFrame.reset()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.add("code-revealed")
    content.classList.remove("request-code")    
    return
        
    
############################################################
export showScreeningsList = ->
    log "showScreeningsList"
    # await cubeModule.waitForTransition()
    codeDisplay.hideCode()
    screeningsList.show()
    cubeModule.reset()
    radiologistImages.reset()
    credentialsFrame.reset()
    requestFrame.reset()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.remove("code-revealed")
    content.classList.remove("request-code")
    return

#endregion
