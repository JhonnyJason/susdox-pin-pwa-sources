############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("codedisplaymodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import * as account from "./accountmodule.js"

############################################################
isRevealed = false
############################################################
currentCode = ""

############################################################
codedisplayContainer = document.getElementById("codedisplay-container")
codeDisplay = document.getElementById("code-display")

############################################################
setCode = (code) ->
    currentCode = code.replaceAll(" ", "")
    codeTokens = []
    codeTokens[0] = currentCode.slice(0,3)
    codeTokens[1] = currentCode.slice(3,6)
    codeTokens[2] = currentCode.slice(6,9)

    codeDisplay.textContent = codeTokens.join("  ")
    return

############################################################
export updateCode = ->
    log "updateCode"
    try
        credentials = account.getUserCredentials()
        setCode(credentials.code)
        if await account.accountIsValid()
            codedisplayContainer.classList.remove("invalid-code")
        else
            codedisplayContainer.classList.add("invalid-code")
    catch err 
        log err    
        codedisplayContainer.classList.remove("invalid-code")
        setCode("")
    return

############################################################
export hideCode = ->
    log "hideCode"
    codedisplayContainer.classList.remove("show-code")
    isRevealed = false
    return

export revealCode = ->
    log "revealCode"
    codedisplayContainer.classList.add("show-code")
    isRevealed = true
    return