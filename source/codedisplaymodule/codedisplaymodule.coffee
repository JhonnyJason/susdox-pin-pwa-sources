############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("codedisplaymodule")
#endregion

############################################################
import * as S from "./statemodule.js"
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
    S.addOnChangeListener("userCredentials", userCredentialsChanged)
    userCredentialsChanged()
    return

############################################################
userCredentialsChanged = ->
    credentials = S.load("userCredentials")
    if credentials? and credentials.code? then setCode(credentials.code)
    else setCode("")
    return

############################################################
reveal = ->
    codedisplayContainer.classList.add("show-code")
    isRevealed = true
    return

############################################################
export setCode = (code) ->
    currentCode = code.replaceAll(" ", "")
    codeTokens = []
    codeTokens[0] = currentCode.slice(0,3)
    codeTokens[1] = currentCode.slice(3,6)
    codeTokens[2] = currentCode.slice(6,9)

    codeDisplay.textContent = codeTokens.join("  ")
    return

export reset = ->
    codedisplayContainer.classList.remove("show-code")
    isRevealed = false
    return

export revealOrCopy = ->
    if !isRevealed then reveal()
    else copyToClipboard(currentCode)
    return
