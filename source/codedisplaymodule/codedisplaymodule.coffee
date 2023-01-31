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

############################################################
reveal = ->
    codedisplayContainer.classList.add("show-code")
    isRevealed = true
    return

############################################################
export setCode = (code) ->
    currentCode = code
    codeDisplay.textContent = code
    return

export reset = ->
    codedisplayContainer.classList.remove("show-code")
    isRevealed = false
    return

export revealOrCopy = ->
    if !isRevealed then reveal()
    else copyToClipboard(currentCode)
    return
