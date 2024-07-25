############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("radiologistdatamodule")
#endregion

############################################################
import QR from "vanillaqr"

############################################################
qrURL = ""
qrSize = 220

############################################################
import * as cubeModule from "./cubemodule.js"
import * as footer from "./footermodule.js"
import * as account from "./accountmodule.js"
import { qrURLBase } from "./configmodule.js"

############################################################
#region internal variables

sustSolLogoURL = "/img/sustsol_logo.png" # must always be -1
sustSolAddress = "SustSol GmbH - 8044 Graz, Mariatroster Strasse 378b/7" # must always be -1

############################################################
imageIndex = 0

############################################################
allImages = []
allImageElements = []

allAddresses = []

#endregion

############################################################
setPosition = (idx) ->
    log "setPosition #{idx}"
    imageIndex = (idx + allImages.length) % allImages.length 

    ## Images
    leftImage = getImageElement(idx - 1)
    frontImage = getImageElement(idx)
    rightImage = getImageElement(idx + 1)
    
    # we already tilted the cube 180° vertically
    cubeModule.setCurrentRightElement(rightImage)
    cubeModule.setCurrentBackElement(frontImage) 
    cubeModule.setCurrentLeftElement(leftImage)

    ## Addresses
    leftAddress = getAddress(idx - 1)
    shownAddress = getAddress(idx)
    rightAddress = getAddress(idx + 1)

    footer.setRightAddress(rightAddress)
    footer.setShownAddress(shownAddress) 
    footer.setLeftAddress(leftAddress)
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
    # olog allImages
    
    url = allImages[idx]
    if url == qrURL then return createQRElement()

    image = document.createElement("img")
    image.src = url
    image.setAttribute("draggable", false)
    return image

createQRElement = ->
    log "createQRElement"
    options = 
        url: qrURL
        size: qrSize
        toTable: false
        ecclevel: 3
        noBorder: true
    
    currentQr = new QR(options)
    # return currentQr.domElement
    return currentQr.toImage("png")


getAddress = (idx) ->
    idx = (idx + allImages.length) % allImages.length
    return allAddresses[idx]

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
    allAddresses = []
    allImageElements = []
    return

############################################################
export loadData = ->
    log "loadData"
    try
        imageURLs = account.getRadiologistImages()
        addresses = account.getRadiologistAddresses()
        if !Array.isArray(imageURLs) then throw new Error("imagesURLs was no Array!")
        if !Array.isArray(addresses) then throw new Error("addresses was no Array!")
        if imageURLs.length != addresses.length then throw new Error("imagesURLs and addresses did not match in size!")
    catch err
        log "Error in loadData: #{err.message}" 
        imageURLs = null
        addresses = null

    # olog {imageURLs, addresses}

    ##if imageURLS exist also addresses exist
    if imageURLs? and imageURLs.length > 0

        userCreds = account.getUserCredentials()
        qrURL =  qrURLBase + userCreds.code
        allImages = [...imageURLs, qrURL]
        # allImages = [...imageURLs, sustSolLogoURL]
        
        allAddresses = [...addresses, sustSolAddress]
        allImageElements = new Array(allImages.length)
        setPosition(imageIndex)
    else if imageURLs? 
        allImages = [sustSolLogoURL]
        allAddresses = [sustSolAddress]
        allImageElements = new Array(allImages.length)
        setPosition(imageIndex)
    else reset()
    return

############################################################
export setSustSolLogo = ->
    log "setSustSolLogo"
    if allImages.length == 0 then return
    if imageIndex == (allImages.length - 1) then return
    if cubeModule.isInTransition() then return

    leftImage = getImageElement(imageIndex - 1)
    leftAddress = getAddress(imageIndex - 1)
    sustSolLogoImage = getImageElement(-1)
    cubeModule.setCurrentLeftElement(sustSolLogoImage)
    footer.setLeftAddress(sustSolAddress)


    try cubeModule.rotateToSustSolLeft()
    catch err
        log err
        cubeModule.setCurrentLeftElement(leftImage)
        footer.setLeftAddress(leftAddress)
    return


export setQRCode = ->
    log "setQRCode"
    ## TODO get right QR code

    ## TODO adjust
    if allImages.length == 0 then return
    if imageIndex == (allImages.length - 1) then return
    if cubeModule.isInTransition() then return

    leftImage = getImageElement(imageIndex - 1)
    leftAddress = getAddress(imageIndex - 1)
    # sustSolLogoImage = getImageElement(-1)
    # cubeModule.setCurrentLeftElement(sustSolLogoImage)
    qrCodeElement = getImageElement(-1)
    cubeModule.setCurrentLeftElement(qrCodeElement)
    footer.setLeftAddress(sustSolAddress)

    try cubeModule.rotateToSustSolLeft()
    catch err
        log err
        cubeModule.setCurrentLeftElement(leftImage)
        footer.setLeftAddress(leftAddress)
    return

############################################################
export sustSolRotateCompleted = ->
    log "sustSolRotateCompleted"
    setPosition(-1)
    return