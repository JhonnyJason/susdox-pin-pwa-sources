############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("credentialsframemodule")
#endregion

############################################################
import * as data from "./datamodule.js"
import * as utl from "./utilmodule.js"
import * as sci from "./scimodule.js"

############################################################
import { NetworkError, InputError, InvalidUserError } from "./errormodule.js"

############################################################
import { ScrollRollDatepicker } from "./scrollrolldatepickermodule.js"

############################################################
#region DOM Cache

credentialsframeContainer = document.getElementById("credentialsframe-container")

############################################################
loginCodeInput = document.getElementById("login-code-input")
loginBirthdayInput = document.getElementById("login-birthday-input")

############################################################
invalidUserErrorFeedback = document.getElementById("invalid-user-error-feedback")
networkErrorFeedback = document.getElementById("network-error-feedback")
inputErrorFeedback = document.getElementById("input-error-feedback")
loginPreloader = document.getElementById("login-preloader")

############################################################
userFeedback = document.getElementById("user-feedback")

#endregion

############################################################
# maxLen = 6
maxLen = 9

############################################################
datePicker = null

############################################################
export initialize = ->
    log "initialize"
    loginCodeInput.addEventListener("keydown", loginCodeInputKeyDowned)
    loginCodeInput.addEventListener("keyup", loginCodeInputKeyUpped)
    
    options = 
        element: "login-birthday-input"
        height: 32
    datePicker = new ScrollRollDatepicker(options)
    datePicker.initialize()
    return

############################################################
loginCodeInputKeyDowned = (evt) ->
    # log "svnPartKeyUpped"
    value = loginCodeInput.value.replaceAll(" ", "").toLowerCase()
    codeLength = value.length
    
    # 46 is delete
    if evt.keyCode == 46 then return    
    # 8 is backspace
    if evt.keyCode == 8 then return
    # 27 is escape
    if evt.keyCode == 27 then return
    
    # We we donot allow the input to grow furtherly
    if codeLength == maxLen
        evt.preventDefault()
        return false
    
    if codeLength > maxLen then loginCodeInput.value = value.slice(0,maxLen)

    okay = utl.isAlphanumericString(evt.key)
    # okay = utl.isBase32String(evt.key)

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
    rawCode = value.replaceAll(" ", "").toLowerCase()
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

    if rLen == 3 || (rLen == 6 && maxLen == 9) then newValue += "  " unless del

    loginCodeInput.value = newValue
    return

############################################################
export extractCredentials = ->
    log "extractCredentials"
    value = loginCodeInput.value
    code = value.replaceAll(" ", "")
    dateOfBirth = loginBirthdayInput.value

    olog {code, dateOfBirth}

    if code.length != maxLen then throw new InputError("Fehler im Code!")
    # if !utl.isBase32String(code) then throw new InputError("Fehler im Code!")
    if !dateOfBirth then throw new InputError("Kein Geburtsdatum gewählt!")

    userFeedback.innerHTML = loginPreloader.innerHTML
    uuid = await sci.getUUID(dateOfBirth, code)
    credentials = { uuid, code, dateOfBirth }
    data.setUserCredentials(credentials)
    loginCodeInput.value = ""
    loginBirthdayInput.value = ""
    userFeedback.innerHTML = ""
    return

############################################################
export resetAllErrorFeedback = ->
    log "resetAllErrorFeedback"
    userFeedback.innerHTML = ""
    credentialsframeContainer.classList.remove("error")
    return

############################################################
export errorFeedback = (error) ->
    log "errorFeedback"

    if error instanceof NetworkError
        credentialsframeContainer.classList.add("error")
        userFeedback.innerHTML = networkErrorFeedback.innerHTML
    if error instanceof InputError 
        credentialsframeContainer.classList.add("error")
        userFeedback.innerHTML = inputErrorFeedback.innerHTML
    if error instanceof InvalidUserError
        credentialsframeContainer.classList.add("error")
        userFeedback.innerHTML = invalidUserErrorFeedback.innerHTML

    return