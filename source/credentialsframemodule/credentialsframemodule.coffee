############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("credentialsframemodule")
#endregion

############################################################
import * as data from "./datamodule.js"
import * as utl from "./utilmodule.js"

############################################################
loginCodeInput = document.getElementById("login-code-input")
loginBirthdayInput = document.getElementById("login-birthday-input")

############################################################
export initialize = ->
    log "initialize"
    loginCodeInput.addEventListener("keydown", loginCodeInputKeyDowned)
    loginCodeInput.addEventListener("keyup", loginCodeInputKeyUpped)
    return


############################################################
loginCodeInputKeyDowned = (evt) ->
    # log "svnPartKeyUpped"
    value = loginCodeInput.value
    codeLength = value.length
    
    # 46 is delete
    if evt.keyCode == 46 then return    
    # 8 is backspace
    if evt.keyCode == 8 then return
    # 27 is escape
    if evt.keyCode == 27 then return
    
    # We we donot allow the input to grow furtherly
    if codeLength == 13
        evt.preventDefault()
        return false
    
    if codeLength > 13 then loginCodeInput.value = ""

    # okay = utl.isAlphanumericString(evt.key)
    okay = utl.isBase32String(evt.key)

    if !okay
        evt.preventDefault()
        return false
    return

############################################################
loginCodeInputKeyUpped = (evt) ->
    # log "svnPartKeyUpped"
    value = loginCodeInput.value
    codeLength = value.length

    codeTokens = []
    rawCode = value.replaceAll(" ", "")
    rLen = rawCode.length
    
    log "rawCode #{rawCode}"
    if rLen > 0
        codeTokens.push(rawCode.slice(0,3))
    if rLen > 3
        codeTokens.push(rawCode.slice(3,6))
    if rLen > 6
        codeTokens.push(rawCode.slice(6))
    newValue = codeTokens.join("  ")
    
    del = evt.keyCode == 46 || evt.keyCode == 8

    if rLen == 3 || rLen == 6 then newValue += "  " unless del

    loginCodeInput.value = newValue
    return

############################################################
export extractCredentials = ->
    log "extractCredentials"
    value = loginCodeInput.value
    code = value.replaceAll(" ", "")
    dateOfBirth = loginBirthdayInput.value

    olog {code, dateOfBirth}

    if code.length != 9 then throw new Error("Fehler im Code!")
    if !utl.isBase32String(code) then throw new Error("Fehler im Code!")
    if !dateOfBirth then throw new Error("Kein Geburtsdatum gewählt!")

    uuid = ""
    credentials = { uuid, code, dateOfBirth }
    data.setUserCredentials(credentials)
    
    loginCodeInput.value = ""
    loginBirthdayInput.value = ""
    return

############################################################
export resetAllErrorFeedback = ->
    log "resetAllErrorFeedback"
    return

############################################################
export errorFeedback = (type, reason) ->
    log "errorFeedback"
    olog {
        type, 
        reason
    }
    return