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
import { NetworkError, InputError, AuthenticationError } from "./errormodule.js"

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
    # runner = 10000
    # code = ""
    # while(runner)
    #     code = runner
    #     runner--
    #     code = loginCodeInput.value 
    # code += "."
    # loginCodeInput.value = code
    # return
    
    # 46 is delete
    if evt.keyCode == 46 then return    
    # 8 is backspace
    if evt.keyCode == 8 then return
    # 27 is escape
    if evt.keyCode == 27 then return
    
    # rawCode = loginCodeInput.value.replaceAll(" ", "").toLowerCase()
    rawCode = loginCodeInput.value.replaceAll(" ", "")
    rLen = rawCode.length
    codeTokens = []
    
    log "rawCode #{rawCode}"
    if rLen > 0
        codeTokens.push(rawCode.slice(0,3))
    if rLen > 3
        codeTokens.push(rawCode.slice(3,6))
    if rLen > 6
        codeTokens.push(rawCode.slice(6))
    newValue = codeTokens.join("  ")

    if (rLen == 3 or rLen == 6) then newValue += "  "    

    loginCodeInput.value = newValue
    return

############################################################
loginCodeInputKeyUpped = (evt) ->
    # log "svnPartKeyUpped"
    # runner = 10000
    # code = ""
    # while(runner)
    #     code = runner
    #     runner--
    #     code = loginCodeInput.value
    # code += "."
    # loginCodeInput.value = code
    # return
    
    # rawCode = loginCodeInput.value.replaceAll(" ", "").toLowerCase()
    rawCode = loginCodeInput.value.replaceAll(" ", "")
    newCode = ""
    # filter out all the illegal characters
    for c in rawCode when utl.isAlphanumericString(c)
        newCode += c

    rLen = newCode.length
    if rLen > 9 then newCode = newCode.slice(0, 9)
    rLen = newCode.length

    codeTokens = []
    
    log "rawCode #{newCode}"
    if rLen > 0
        codeTokens.push(newCode.slice(0,3))
    if rLen > 3
        codeTokens.push(newCode.slice(3,6))
    if rLen > 6
        codeTokens.push(newCode.slice(6))
    newValue = codeTokens.join("  ")

    loginCodeInput.value = newValue
    return

############################################################
export extractCredentials = ->
    log "extractCredentials"
    code = loginCodeInput.value.replaceAll(" ", "")
    # dateOfBirth = loginBirthdayInput.value
    dateOfBirth = datePicker.value

    olog {code, dateOfBirth}

    if !(code.length == 6 or code.length == 9) then throw new InputError("Fehler im Code!")
    # if !utl.isBase32String(code) then throw new InputError("Fehler im Code!")
    if !dateOfBirth then throw new InputError("Kein Geburtsdatum gewählt!")

    credentials = { code, dateOfBirth }
    loginBody = utl.loginRequestBody(credentials)
    userFeedback.innerHTML = loginPreloader.innerHTML

    rersponse = await sci.loginRequest(loginBody)
    log "#{await response.text()}"

    data.setUserCredentials(credentials)    
    # datePicker.reset()
    loginCodeInput.value = ""
    loginBirthdayInput.value = ""
    userFeedback.innerHTML = ""
    return

############################################################
export makeAcceptable = ->
    log "makeAcceptable"
    if datePicker.isOn then datePicker.acceptCurrentPositions()
    if datePicker.isOn then return false
    return true

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
        return
    
    if error instanceof InputError
        credentialsframeContainer.classList.add("error")
        userFeedback.innerHTML = inputErrorFeedback.innerHTML
        return

    if error instanceof AuthenticationError
        credentialsframeContainer.classList.add("error")
        userFeedback.innerHTML = invalidUserErrorFeedback.innerHTML
        return

    credentialsframeContainer.classList.add("error")
    userFeedback.innerHTML = "Unexptected Error occured!"
    return