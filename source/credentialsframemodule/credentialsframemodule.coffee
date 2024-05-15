############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("credentialsframemodule")
#endregion

############################################################
import * as nav from "navhandler"

############################################################
import * as requestCodeFrame from "./requestcodeframemodule.js"
import * as account from "./accountmodule.js"
import * as utl from "./utilmodule.js"
import * as sci from "./scimodule.js"
import { acceptButtonClicked } from "./mainbuttonmodule.js"

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
userFeedback = credentialsframeContainer.getElementsByClassName("user-feedback")[0]

#endregion

############################################################
datePicker = null

############################################################
currentCode = ""

############################################################
accountToUpdate = null

############################################################
export initialize = ->
    log "initialize"
    loginPreloader = loginPreloader.parentNode.removeChild(loginPreloader)

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
    # log "loginCodeInputKeyDowned"
    
    # 13 is enter
    if evt.keyCode == 13
        evt.preventDefault()
        acceptButtonClicked()
        return    
    # 46 is delete
    if evt.keyCode == 46 then return    
    # 8 is backspace
    if evt.keyCode == 8 then return
    # 27 is escape
    if evt.keyCode == 27 then return

    rawCode = loginCodeInput.value.replaceAll(" ", "").toLowerCase()
    if rawCode != currentCode then rawCode = currentCode
    rLen = rawCode.length

    codeTokens = []
    
    if rLen > 0
        codeTokens.push(rawCode.slice(0,3))
    if rLen > 3
        codeTokens.push(rawCode.slice(3,6))
    if rLen > 6
        codeTokens.push(rawCode.slice(6))
    newValue = codeTokens.join("  ")

    if (rLen == 3 or rLen == 6) then rawCode += "  "    

    loginCodeInput.value = newValue
    return

############################################################
loginCodeInputKeyUpped = (evt) ->
    # log "loginCodeInputKeyUpped"
    
    rawCode = loginCodeInput.value.replaceAll(" ", "").toLowerCase()
    log "rawCode #{rawCode}"
    newCode = ""
    # filter out all the illegal characters
    for c in rawCode when utl.isAlphanumericString(c)
        newCode += c

    rLen = newCode.length
    if rLen > 9 then newCode = newCode.slice(0, 9)
    currentCode = newCode
    rLen = newCode.length

    codeTokens = []
    
    log "newCode #{newCode}"
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
extractCredentials = ->
    log "extractCredentials"
    code = loginCodeInput.value.replaceAll(" ", "").toLowerCase()
    # dateOfBirth = loginBirthdayInput.value
    dateOfBirth = datePicker.value

    # olog {code, dateOfBirth}

    if code.length == 8 and (code.indexOf("at")==0) then code = code.slice(2)
    # log code

    if !(code.length == 6 or code.length == 9) then throw new InputError("Fehler im Code!")
    # if !utl.isBase32String(code) then throw new InputError("Fehler im Code!")
    if !dateOfBirth then throw new InputError("Kein Geburtsdatum gewählt!")

    credentials = { code, dateOfBirth }
    userFeedback.innerHTML = loginPreloader.innerHTML

    loginBody = await utl.loginRequestBody(credentials)
    response = await sci.loginRequest(loginBody)
    if response? and response.name? then credentials.name = response.name 
    
    return credentials


############################################################
makeAcceptable = ->
    log "makeAcceptable"
    if datePicker.isOn then datePicker.acceptCurrentPositions()
    if datePicker.isOn then return false
    return true

############################################################
export getBirthdayValue = ->
    log "getBirthdayValue"
    return datePicker.value

export isUpdate = -> return accountToUpdate?


############################################################
export acceptInput = ->
    log "acceptInput"
    try
        acceptable = makeAcceptable() # checks for acceptable datepicker state
        if !acceptable then return 

        resetAllErrorFeedback()
        credentials = await extractCredentials() # also checks if they are valid

        if accountToUpdate? 
            # we just updated an account - update credentials and save
            accountToUpdate.userCredentials = credentials
            account.saveAllAccounts()

        else account.addValidAccount(credentials)
            
        # update or adding an account succeeded - so back to root :-)
        await nav.toRoot(true) 
    catch err
        log err
        errorFeedback(err)
    return

############################################################
export resetAllErrorFeedback = ->
    log "resetAllErrorFeedback"
    userFeedback.innerHTML = ""
    credentialsframeContainer.classList.remove("error")
    return

############################################################
errorFeedback = (error) ->
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


############################################################
#region UI States handles
export prepareForCodeUpdate = ->
    log "prepareForCodeUpdate"
    resetAllErrorFeedback()
    accountToUpdate = account.getAccountObject()
    # olog accountToUpdate
    
    datePicker.setValue(accountToUpdate.userCredentials.dateOfBirth)
    datePicker.freeze()
    return

############################################################
export prepareForAddCode = ->
    log "prepareForAddCode"
    resetAllErrorFeedback()
    accountToUpdate = null
    datePicker.reset()
    loginBirthdayInput.value = ""

    dateOfBirth = requestCodeFrame.getBirthdayValue()
    log dateOfBirth
    if dateOfBirth? and dateOfBirth then datePicker.setValue(dateOfBirth)

    loginCodeInput.value = ""
    currentCode = ""
    return

############################################################
export reset = ->
    log "reset"
    resetAllErrorFeedback()
    accountToUpdate = null
    datePicker.reset()
    loginBirthdayInput.value = ""
    
    loginCodeInput.value = ""
    currentCode = ""
    return


#endregion