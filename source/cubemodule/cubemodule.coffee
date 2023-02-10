############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("cubemodule")
#endregion

############################################################
import * as codeDisplay from "./codedisplaymodule.js"
import * as radiologistImages from "./radiologistimagemodule.js"

############################################################
arrowLeft = document.getElementById("arrow-left")
arrowRight = document.getElementById("arrow-right")

############################################################
cubeFront = document.getElementById("cube-front")
cubeLeft = document.getElementById("cube-left")
cubeBack = document.getElementById("cube-back")
cubeRight = document.getElementById("cube-right")


############################################################
positionToClass = []
positionToClass[0] = "position-0"
positionToClass[1] = "position-1"
positionToClass[2] = "position-2"
positionToClass[3] = "position-3"

############################################################
export initialize = ->
    log "initialize"
    arrowLeft.addEventListener("click", arrowLeftClicked)
    arrowRight.addEventListener("click", arrowRightClicked)

    return

############################################################
arrowLeftClicked = (evnt) ->
    log "arrowLeftClicked"
    codeDisplay.reset()
    radiologistImages.shiftLeft()
    return    

############################################################
arrowRightClicked = (evnt) ->
    log "arrowRightClicked"
    codeDisplay.reset()
    radiologistImages.shiftRight()    
    return


############################################################
export setFrontElement = (el) ->
    cubeFront.replaceChildren(el)
    return

export setLeftElement = (el) ->
    cubeLeft.replaceChildren(el)
    return

export setBackElement = (el) ->
    cubeBack.replaceChildren(el)
    return

export setRightElement = (el) ->
    cubeRight.replaceChildren(el)
    return

############################################################
export setHorizontalPosition = (pos) ->
    pos = (pos + 4) % 4
    for className,i in positionToClass
        if pos == i then content.classList.add(className)
        else content.classList.remove(className)
    return
