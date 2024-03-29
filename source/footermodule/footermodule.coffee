############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("footermodule")
#endregion

############################################################
import * as radiologistData from "./radiologistdatamodule.js"

############################################################
#region DOM cache

footer = document.getElementById("address-display")

############################################################
footer0 = document.getElementById("display-0")
footer1 = document.getElementById("display-1")
footer2 = document.getElementById("display-2")

############################################################
sustSolAddress = "SustSol GmbH - 8044 Graz, Mariatroster Strasse 378b/7"

#endregion

############################################################
#region internal Variables

footerPosition = 0

############################################################
footerLeft = footer0  
footerShown = footer1
footerRight = footer2

#endregion

############################################################
#region exported Functions

## rotation functions - called by cubemodule
############################################################
export rotateLeft = ->
    footer.classList.remove("no-transition")
    footer.classList.remove("position-#{footerPosition}")
    footerPosition++
    footer.classList.add("position-#{footerPosition}")
    return

export rotateRight = ->
    footer.classList.remove("no-transition")
    footer.classList.remove("position-#{footerPosition}")
    footerPosition--
    footer.classList.add("position-#{footerPosition}")
    return


############################################################
export postRotationCorrection = ->
    log "postRotationCorrection"
    footer.classList.add("no-transition")
    log "footerPosition: #{footerPosition}"

    footer.classList.remove("position-#{footerPosition}")
    footerPosition = 0
    footer.classList.add("position-#{footerPosition}")
    return

## set addresses from outsite - radiologistDataModule
############################################################
export setLeftAddress = (address) ->
    footerLeft.textContent = address
    return

export setShownAddress = (address) ->
    footerShown.textContent = address
    return

export setRightAddress = (address) ->
    footerRight.textContent = address
    return


############################################################
export reset = ->
    log "reset"
    footerPosition = 0
    positionClass = "position-#{footerPosition}"

    setLeftAddress(sustSolAddress)
    setShownAddress(sustSolAddress)
    setRightAddress(sustSolAddress)
    return

#endregion