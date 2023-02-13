############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("radiologistimagemodule")
#endregion

############################################################
import *  as cubeModule from "./cubemodule.js"

############################################################
imageIndex = 0
cubePosition = 0

############################################################
allImages = [
    "/img/umschaden-logo.png"
    "/img/karner-logo.jpg"
    "/img/sustsol_logo.png"
]

############################################################
allImageElements = []

############################################################
export initialize = ->
    log "initialize"
    ## TODO get images via service worker

    if allImages?
        allImageElements = new Array(allImages.length) 
        setPosition(0)
    return


############################################################
setPosition = (idx) ->
    imageIndex = (idx + allImages.length) % allImages.length 

    leftImage = getImageElement(idx - 1)
    frontImage = getImageElement(idx)
    rightImage = getImageElement(idx + 1)
    

    cubeModule.setCurrentRightElement(rightImage)
    cubeModule.setCurrentBackElement(frontImage)
    cubeModule.setCurrentLeftElement(leftImage)
    return

############################################################
getImageElement = (idx) ->
    idx = (idx + allImages.length) % allImages.length
    if allImageElements[idx]? then return allImageElements[idx]
    else allImageElements[idx] = createImageElement(idx)
    return allImageElements[idx]

createImageElement = (idx) ->
    log "createImageElement"
    idx = (idx + allImages.length) % allImages.length
    log "idx: #{idx}"
    olog allImages
    
    image = document.createElement("img")
    image.src = allImages[idx]
    image.setAttribute("draggable", false)
    return image

############################################################
shift = (direction) -> setPosition(imageIndex + direction)

############################################################
export shiftLeft = ->
    log "shiftLeft"
    direction = 1
    shift(direction)
    return

############################################################
export shiftRight = ->
    log "shiftRight"
    direction = -1
    shift(direction)
    return

############################################################
export reset = ->
    log "reset"
    ## TOOD remove all images
    return

export loadImages = ->
    log "loadImages"
    ## TODO load images
    if allImages?
        allImageElements = new Array(allImages.length) 
        setPosition(0)
    return