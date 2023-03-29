############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("confirmationpopupmodule")
#endregion

############################################################
import * as sci from "./scimodule.js"
import * as utl from "./utilmodule.js"

############################################################
import { NetworkError, InputError, ValidationError, ExpiredTokenError, InvalidTokenError } from "./errormodule.js"

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
token = ""

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
confirmButtonClicked = ->
    log "confirmButtonClicked"
    confirmButton.classList.add("disabled")
    try
        resetAllErrorFeedback()
        userFeedback.innerHTML = confirmationPreloader.innerHTML
        # dateOfBirth = confirmationpopupBirthdayInput.value
        dateOfBirth = datePicker.value
        if !dateOfBirth then throw new InputError("No dateOfBirth provided!")
        
        credentials = await sci.getCredentials(token, dateOfBirth)
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

    if error instanceof ValidationError 
        confirmationpopupContent.classList.add("error")
        confirmationpopupBirthdayInput.classList.add("error")
        userFeedback.innerHTML = inputErrorFeedback.innerHTML
        return

    if error instanceof InvalidTokenError
        confirmationpopupContent.classList.add("error")
        userFeedback.innerHTML = invalidTokenErrorFeedback.innerHTML
        return

    if error instanceof ExpiredTokenError
        confirmationpopupContent.classList.add("error")
        userFeedback.innerHTML = expiredTokenErrorFeedback.innerHTML
        return

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
export pickUpConfirmedCredentials = (givenToken) ->
    log "userBirthdayConfirm"
    token = givenToken
    confirmationpopup.classList.add("shown")

    credentialsPromise = new Promise (resolve, reject) ->
        credentialsPromiseAccept = resolve
        credentialsPromiseReject = reject

    return credentialsPromise
