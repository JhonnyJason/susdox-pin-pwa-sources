############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as radiologistImages from "./radiologistimagemodule.js"
import * as cubeModule from "./cubemodule.js"

############################################################
#region State Setter Functions
export setToDefaultState = ->
    ## prod log "setToDefaultState"
    # await cubeModule.waitForTransition()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")

    cubeModule.reset()
    radiologistImages.reset()
    return

############################################################
export setToAddCodeState = ->
    ## prod log "setToAddCodeState"
    # await cubeModule.waitForTransition()

    content.classList.remove("preload")
    content.classList.remove("pre-user-images")
    content.classList.remove("user-images")
    content.classList.add("add-code")

    cubeModule.reset()
    radiologistImages.reset()
    return

############################################################
export setToPreUserImagesState = ->
    ## prod log "setToPreUserImagesState"
    # await cubeModule.waitForTransition()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.add("pre-user-images")
    content.classList.remove("user-images")
    
    cubeModule.reset()
    radiologistImages.reset()
    return

############################################################
export setToUserImagesState = ->
    ## prod log "setToUserImagesState"
    await cubeModule.waitForTransition()

    content.classList.remove("preload")
    content.classList.remove("add-code")
    content.classList.remove("pre-user-images")
    content.classList.add("user-images")
    
    cubeModule.allowTouch()
    radiologistImages.loadImages()
    return

#endregion
