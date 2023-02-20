############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("radiologistimagemodule")
#endregion

############################################################
import *  as cubeModule from "./cubemodule.js"
import *  as S from "./statemodule.js"

############################################################
#region internal variables

sustSolLogoURL = "/img/sustsol_logo.png" # must always be -1

############################################################
imageIndex = 0

############################################################
allImages = []
allImageElements = []

#endregion

############################################################
export initialize = ->
    log "initialize"
    # changeDetect = (el1, el2) -> JSON.stringify(el1) != JSON.stringify(el2) 
    # S.setChangeDetectionFunction("radiologistImages", changeDetect)
    S.addOnChangeListener("radiologistImages", imagesChanged)
    return

############################################################
imagesChanged = ->
    log "imagesChanged"
    imageURLs = S.load("radiologistImages")

    if imageURLs? and Array.isArray(imageURLs) and imageURLs.length > 0
        allImages = [...imageURLs, sustSolLogoURL]
        allImageElements = new Array(allImages.length) 
        setPosition(imageIndex)
    else if imageURLs? and Array.isArray(imageURLs)
        allImages = [sustSolLogoURL]
        allImageElements = new Array(allImages.length) 
        setPosition(imageIndex)
    else reset()
    return

############################################################
setPosition = (idx) ->
    log "setPosition #{idx}"
    imageIndex = (idx + allImages.length) % allImages.length 

    leftImage = getImageElement(idx - 1)
    frontImage = getImageElement(idx)
    rightImage = getImageElement(idx + 1)
    
    # we already tilted the cube 180° vertically
    cubeModule.setCurrentRightElement(rightImage)
    cubeModule.setCurrentBackElement(frontImage) 
    cubeModule.setCurrentLeftElement(leftImage)
    return

############################################################
getImageElement = (idx) ->
    idx = (idx + allImages.length) % allImages.length
    if allImageElements[idx]? then return allImageElements[idx].cloneNode()
    else allImageElements[idx] = createImageElement(idx)
    return allImageElements[idx].cloneNode()

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
    imageIndex = 0
    allImages = []
    allImageElements = []
    return

############################################################
export loadImages = -> imagesChanged()

############################################################
export setSustSolLogo = ->
    log "setSustSolLogo"
    if imageIndex == (allImages.length - 1) then return
    if cubeModule.isInTransition() then return

    leftImage = getImageElement(imageIndex - 1)
    sustSolLogoImage = getImageElement(-1)
    cubeModule.setCurrentLeftElement(sustSolLogoImage)
    
    try cubeModule.rotateToSustSolLeft()
    catch err
        log err
        cubeModule.setCurrentLeftElement(leftImage)

    return

############################################################
export sustSolRotateCompleted = ->
    log "sustSolRotateCompleted"
    setPosition(-1)
    return