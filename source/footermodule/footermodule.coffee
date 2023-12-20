############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("footermodule")
#endregion

############################################################
import * as radiologistData from "./radiologistdatamodule.js"

############################################################
#region DOM cache

footer = document.getElementById("footer")

############################################################
footer0 = document.getElementById("footer-0")
footer1 = document.getElementById("footer-1")
footer2 = document.getElementById("footer-2")
footer3 = document.getElementById("footer-3")

############################################################
## TODO figure out if this is needed
sustsolCubeImage = document.getElementById("sustsol-cube-image")
sustSolAddress = "SustSol GmbH - 8044 Graz, Mariatroster Strasse 378b/7"

#endregion

############################################################
#region internal Variables

footerPosition = 0

############################################################
footerLeft = footer0  
footerMiddle = footer1
footerRight = footer2
footerHidden = footer3

#endregion

############################################################
#region exported Functions

## rotation functions - called by cubemodule
############################################################
export rotateLeft = ->
    content.classList.remove("no-transition")
    cubeElement.removeAttribute("style")
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

export rotateRight = ->
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

## set addresses from outsite - radiologistDataModule
############################################################
export setLeftAddress = (address) ->
    footerLeft.textContent = address
    return

export setShownAddress = (address) ->
    footerMiddle.textContent = address
    return

export setRightAddress = (address) ->
    footerRight.textContent = address
    return

export setHiddenAddress = (address) ->
    footerHdden.textContent = address
    return

############################################################
export reset = ->
    log "reset"
    footerPosition = 0
    positionClass = "position-#{footerPosition}"

    footerLeft = footer0  
    footerMiddle = footer1
    footerRight = footer2
    footerHidden = footer3

    setShownAddress(sustSolAddress)
    return

#endregion