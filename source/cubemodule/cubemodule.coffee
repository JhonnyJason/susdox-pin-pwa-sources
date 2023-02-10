############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("cubemodule")
#endregion

############################################################
import * as codeDisplay from "./codedisplaymodule.js"

############################################################
arrowLeft = document.getElementById("arrow-left")
arrowRight = document.getElementById("arrow-right")

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
    # radiologistFrame.shiftLeft()
    return    

############################################################
arrowRightClicked = (evnt) ->
    log "arrowRightClicked"
    codeDisplay.reset()
    # radiologistFrame.shiftRight()    
    return
    
