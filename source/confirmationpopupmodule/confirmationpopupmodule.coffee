############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("confirmationpopupmodule")
#endregion

############################################################
import * as sci from "./scimodule.js"
import * as utl from "./utilmodule.js"

############################################################
import { NetworkError, InputError, AuthenticationError } from "./errormodule.js"

############################################################
import { ScrollRollDatepicker } from "./scrollrolldatepickermodule.js"

############################################################
#region DOM Cache
# confirmationpopupContent = document.getElementById("confirmationpopup-content")

############################################################
# confirmationpopupBirthdayInput = document.getElementById("confirmationpopup-birthday-input")

############################################################
invalidTokenErrorFeedback = document.getElementById("invalid-token-error-feedback")
expiredTokenErrorFeedback = document.getElementById("expired-token-error-feedback")
networkErrorFeedback = document.getElementById("network-error-feedback")
inputErrorFeedback = document.getElementById("confirmation-error-feedback")
confirmationPreloader = document.getElementById("confirmation-preloader")

############################################################
userFeedback = document.getElementById("confirmationpopup-user-feedback")
confirmButton = document.getElementById("confirmationpopup-confirm-button")

#endregion

############################################################
credentialsPromiseReject = null
credentialsPromiseAccept = null
code = ""

############################################################
datePicker = null

############################################################
export initialize = ->
    log "initialize"
    confirmButton.addEventListener("click", confirmButtonClicked)
    confirmationpopupCloseButton.addEventListener("click", closeButtonClicked)
    
    element = "confirmationpopup-birthday-input"
    datePicker = new ScrollRollDatepicker({element})
    await datePicker.initialize()
    
    olog datePicker
    return

############################################################
makeAcceptable = ->
    log "makeAcceptable"
    if datePicker.isOn then datePicker.acceptCurrentPositions()
    if datePicker.isOn then return false
    return true

############################################################
confirmButtonClicked = ->
    log "confirmButtonClicked"
    confirmButton.classList.add("disabled")
    try
        if !makeAcceptable() then return
        resetAllErrorFeedback()
        # dateOfBirth = confirmationpopupBirthdayInput.value
        dateOfBirth = datePicker.value
        if !dateOfBirth then throw new InputError("No dateOfBirth provided!")
        
        credentials = {code, dateOfBirth}
        loginBody = utl.loginRequestBody(credentials)
        userFeedback.innerHTML = confirmationPreloader.innerHTML
        
        rersponse = await sci.loginRequest(loginBody)
        log "#{await response.text()}"

        resetAllErrorFeedback()
        confirmationpopup.classList.remove("shown")
        credentialsPromiseAccept(credentials)
    catch err then errorFeedback(err)
    finally confirmButton.classList.remove("disabled")
    return

closeButtonClicked = ->
    log "closeButtonClicked"
    confirmationpopup.classList.remove("shown")
    credentialsPromiseReject("User Cancelled!")
    return        # await utl.waitMS(5000)


############################################################
errorFeedback = (error) ->
    log "errorFeedback"
    log error

    # NetworkError, InputError, ValidationError, ExpiredTokenError, InvalidTokenError

    if error instanceof NetworkError
        confirmationpopupContent.classList.add("error")
        userFeedback.innerHTML = networkErrorFeedback.innerHTML
        return

    if error instanceof InputError
        confirmationpopupContent.classList.add("error")
        confirmationpopupBirthdayInput.classList.add("error")
        userFeedback.innerHTML = inputErrorFeedback.innerHTML
        return

    if error instanceof AuthenticationError 
        confirmationpopupContent.classList.add("error")
        confirmationpopupBirthdayInput.classList.add("error")
        userFeedback.innerHTML = inputErrorFeedback.innerHTML
        return

    # if error instanceof InvalidTokenError
    #     confirmationpopupContent.classList.add("error")
    #     userFeedback.innerHTML = invalidTokenErrorFeedback.innerHTML
    #     return

    # if error instanceof ExpiredTokenError
    #     confirmationpopupContent.classList.add("error")
    #     userFeedback.innerHTML = expiredTokenErrorFeedback.innerHTML
    #     return

    confirmationpopupContent.classList.add("error")
    userFeedback.innerHTML = "Unexptected Error occured!"


    return

############################################################
resetAllErrorFeedback = ->
    log "resetAllErrorFeedback"
    confirmationpopupContent.classList.remove("error")
    confirmationpopupBirthdayInput.classList.remove("error")
    userFeedback.innerHTML = ""
    return

############################################################
export pickUpConfirmedCredentials = (givenCode) ->
    log "userBirthdayConfirm"
    code = givenCode
    confirmationpopup.classList.add("shown")

    credentialsPromise = new Promise (resolve, reject) ->
        credentialsPromiseAccept = resolve
        credentialsPromiseReject = reject

    return credentialsPromise
