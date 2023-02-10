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

imageSetter = [
    cubeModule.setBackElement
    cubeModule.setLeftElement
    cubeModule.setFrontElement
    cubeModule.setRightElement
]

############################################################
export initialize = ->
    log "initialize"
    ## TODO get images via service worker

    if allImages? then setPosition(0, 0)
    return


############################################################
setPosition = (idx, pos) ->
    imageIndex = (idx + allImages.length) % allImages.length 
    cubePosition = (pos + 4) % 4

    prevImage = createImage(idx - 1)
    centerImage = createImage(idx)
    nextImage = createImage(idx + 1)

    setImageToPos(prevImage, pos - 1)
    setImageToPos(centerImage, pos)
    setImageToPos(nextImage, pos + 1)

    cubeModule.setHorizontalPosition(pos)
    return

############################################################
createImage = (idx) ->
    idx = (idx + allImages.length) % allImages.length
    image = document.createElement("img")
    image.src = allImages[idx]
    return image

############################################################
setImageToPos = (image, pos) ->
    pos = (pos + 4) % 4
    imageSetter[pos](image)
    return

############################################################
shift = (direction) ->
    newImageIndex = imageIndex + direction
    newCubePosition = cubePosition + direction
    setPosition(newImageIndex, newCubePosition)
    return

############################################################
export shiftLeft = ->
    direction = 1
    shift(direction)
    return

############################################################
export shiftRight = ->
    direction = -1
    shift(direction)
    return
