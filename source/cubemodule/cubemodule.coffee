############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("cubemodule")
#endregion

############################################################
import * as codeDisplay from "./codedisplaymodule.js"
import * as radiologistImages from "./radiologistimagemodule.js"

############################################################
#region DOM cache

arrowLeft = document.getElementById("arrow-left")
arrowRight = document.getElementById("arrow-right")

############################################################
cubeFront = document.getElementById("cube-front")
cubeLeft = document.getElementById("cube-left")
cubeBack = document.getElementById("cube-back")
cubeRight = document.getElementById("cube-right")

############################################################
sustsolCubeImage = document.getElementById("sustsol-cube-image")
imagesPreloader = document.getElementById("images-preloader")

############################################################
cubeArea = document.getElementById("cube-area")
cubeElement = document.getElementById("cube")

#endregion

############################################################
#region internal Variables

cubePosition = 0

############################################################
currentFront = cubeFront  
currentLeft = cubeLeft
currentBack = cubeBack
currentRight = cubeRight

############################################################
actionAfterRotation = null
transitioning = false

############################################################
touching = false
# touchStartX = 0
screenWidth = 0 

#endregion


############################################################
export initialize = ->
    log "initialize"
    arrowLeft.addEventListener("click", arrowLeftClicked)
    arrowRight.addEventListener("click", arrowRightClicked)
    cube.addEventListener("transitionend", cubeTransitionEnded)

    cubeArea.addEventListener("touchstart", touchStarted)
    document.addEventListener("touchend", touchEnded)
    document.addEventListener("touchmove", touchMoved)

    cubeArea.addEventListener("mousedown", mouseDowned)
    document.addEventListener("mouseup", mouseUpped)
    document.addEventListener("mousemove", mouseMoved)

    screenWidth = window.innerWidth
    return

############################################################
#region Event Listeners

############################################################
mouseDowned = (evnt) ->
    log "mouseDowned"
    # touchStartX = evnt.clientX
    # log touchStartX
    touching = true
    return

touchStarted = (evnt) ->
    log "touchStarted"
    return unless evnt.touches.length == 1
    # touchStartX = evnt.touches[0].clientX
    # log touchStartX
    touching = true
    return

############################################################
touchEnded = -> touching = false
mouseUpped = -> touching = false

############################################################
mouseMoved = (evnt) ->
    # log "mouaseMoved"
    return if transitioning
    return unless touching 
    x = evnt.clientX
    # distance = x - touchStartX
    # log distance

    center = 0.5 * screenWidth
    dif = center - x
    
    # log dif
    if dif > 110 then return arrowLeftClicked()
    if dif < -110 then return arrowRightClicked()
    
    tiltDeg = (45.0 * dif) / 110
    addRotationTilt(tiltDeg)
    return


touchMoved = (evnt) ->
    # log "touchMoved"
    return if transitioning
    return unless touching
    x = evnt.touches[0].clientX
    # log x
    center = 0.5 * screenWidth
    dif = center - x
    
    # log dif
    if dif > 110 then return arrowLeftClicked()
    if dif < -110 then return arrowRightClicked()
    
    tiltDeg = (45.0 * dif) / 110
    addRotationTilt(tiltDeg)
    return

############################################################
cubeTransitionEnded = (evnt) ->
    log "cubeTransitionEnded"
    if actionAfterRotation? then actionAfterRotation()
    actionAfterRotation = null
    if cubePosition == -1 or cubePosition == 4
        log "cubePosition: #{cubePosition}"
        content.classList.add("no-transition")
        content.classList.remove("position-#{cubePosition}")
        cubePosition = (cubePosition + 4) % 4
        content.classList.add("position-#{cubePosition}")
    transitioning = false
    return

############################################################
arrowLeftClicked = (evnt) ->
    log "arrowLeftClicked"
    return if transitioning
    codeDisplay.reset()
    actionAfterRotation = radiologistImages.shiftLeft
    transitioning =  true
    touching = false
    rotateLeft()
    return    

############################################################
arrowRightClicked = (evnt) ->
    log "arrowRightClicked"
    return if transitioning
    codeDisplay.reset()
    actionAfterRotation = radiologistImages.shiftRight    
    transitioning = true
    touching = false
    rotateRight()
    return

#endregion

############################################################
#region rotation Functions

addRotationTilt = (tilt) ->
    log "addRotationTilt"
    switch cubePosition
        when -1 then baseRotation = -90
        when 0 then baseRotation = 0
        when 1 then baseRotation = 90
        when 2 then baseRotation = 180
        when 3 then baseRotation = 270
        when 4 then baseRotation = -360
        else log "cubePosition not in regular range(0-3): #{cubePosition}"
    
    rotation = baseRotation + tilt

    content.classList.add("no-transition")
    cubeElement.style.transform = "scale(0.84) rotateX(180deg) rotateY(#{rotation}deg)"
    return

############################################################
rotateLeft = ->
    cubeElement.removeAttribute("style")
    content.classList.remove("no-transition")
    content.classList.remove("position-#{cubePosition}")
    cubePosition++
    content.classList.add("position-#{cubePosition}")

    temp = currentFront
    currentFront = currentLeft
    currentLeft = currentBack
    currentBack = currentRight
    currentRight = temp
    setCurrentFrontElement(sustsolCubeImage)
    return

rotateRight = ->
    cubeElement.removeAttribute("style")
    content.classList.remove("no-transition")
    content.classList.remove("position-#{cubePosition}")
    cubePosition--
    content.classList.add("position-#{cubePosition}")

    temp = currentFront
    currentFront = currentRight
    currentRight = currentBack
    currentBack = currentLeft
    currentLeft = temp
    setCurrentFrontElement(sustsolCubeImage)
    return

#endregion

############################################################
#region exported Functions

export setCurrentFrontElement = (el) ->
    currentFront.replaceChildren(el)
    return

export setCurrentLeftElement = (el) ->
    currentLeft.replaceChildren(el)
    return

export setCurrentBackElement = (el) ->
    currentBack.replaceChildren(el)
    return

export setCurrentRightElement = (el) ->
    currentRight.replaceChildren(el)
    return

############################################################
export reset = ->
    log "reset"
    positionClass = "position-#{cubePosition}"
    cubePosition = 0

    currentFront = cubeFront  
    currentLeft = cubeLeft
    currentBack = cubeBack
    currentRight = cubeRight

    setCurrentFrontElement(sustsolCubeImage)

    finishReset = ->
        content.classList.remove("no-transition")
        content.classList.remove(positionClass)
        setCurrentBackElement("")
        setCurrentLeftElement("")
        setCurrentRightElement("")

    transitioning = true
    actionAfterRotation = finishReset
    return

#endregion