############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("codedisplaymodule")
#endregion

############################################################
import {copyToClipboard} from "./utilmodule.js"

############################################################
isRevealed = false
############################################################
currentCode = ""

############################################################
codedisplayContainer = document.getElementById("codedisplay-container")
codeDisplay = document.getElementById("code-display")

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

export setCode = (code) ->
    currentCode = code
    codeDisplay.textContent = code
    return

export reset = ->
    codedisplayContainer.classList.remove("show-code")
    return

export revealOrCopy = ->
    if !isRevealed then codedisplayContainer.classList.add("show-code")
    else copyToClipboard(currentCode)
    return
