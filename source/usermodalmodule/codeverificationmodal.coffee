############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("codeverificationmodule")
#endregion

############################################################
import * as sci from "./scimodule.js"
import * as utl from "./utilmodule.js"
import { ModalCore } from "./modalcore.js"

############################################################
import { NetworkError, InputError, AuthenticationError } from "./errormodule.js"

############################################################
import { ScrollRollDatepicker } from "./scrollrolldatepickermodule.js"

############################################################
#region DOM Cache
codeverificationContent = codeverificationmodal.getElementsByClassName("modal-content")[0]

############################################################
# codeverificationBirthdayInput = document.getElementById("codeverification-birthday-input")

############################################################
invalidTokenErrorFeedback = document.getElementById("invalid-token-error-feedback")
expiredTokenErrorFeedback = document.getElementById("expired-token-error-feedback")
networkErrorFeedback = document.getElementById("network-error-feedback")
inputErrorFeedback = document.getElementById("confirmation-error-feedback")
confirmationPreloader = document.getElementById("confirmation-preloader")

############################################################
userFeedback = document.getElementById("codeverification-user-feedback")
confirmButton = document.getElementById("codeverification-confirm-button")

#endregion

############################################################
code = ""

############################################################
datePicker = null
modalCore = null

############################################################
export initialize = ->
    log "initialize"
    modalCore = new ModalCore(codeverificationmodal)
    modalCore.connectDefaultElements()
    # confirm button is not default modal element
    confirmButton.addEventListener("click", confirmButtonClicked)
    
    element = "codeverification-birthday-input"
    datePicker = new ScrollRollDatepicker({element})
    await datePicker.initialize()
    
    # olog datePicker
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
        userFeedback.innerHTML = confirmationPreloader.innerHTML
        # dateOfBirth = codeverificationBirthdayInput.value
        dateOfBirth = datePicker.value
        if !dateOfBirth then throw new InputError("No dateOfBirth provided!")
        
        credentials = {code, dateOfBirth}
        loginBody = await utl.loginRequestBody(credentials)
        
        response = await sci.loginRequest(loginBody)
        log response

        resetAllErrorFeedback()
        modalCore.accept(credentials)
    catch err then errorFeedback(err)
    finally confirmButton.classList.remove("disabled")
    return

############################################################
errorFeedback = (error) ->
    log "errorFeedback"
    log error

    # NetworkError, InputError, ValidationError, ExpiredTokenError, InvalidTokenError

    if error instanceof NetworkError
        codeverificationContent.classList.add("error")
        userFeedback.innerHTML = networkErrorFeedback.innerHTML
        return

    if error instanceof InputError
        codeverificationContent.classList.add("error")
        codeverificationBirthdayInput.classList.add("error")
        userFeedback.innerHTML = inputErrorFeedback.innerHTML
        return

    if error instanceof AuthenticationError
        codeverificationContent.classList.add("error")
        codeverificationBirthdayInput.classList.add("error")
        userFeedback.innerHTML = inputErrorFeedback.innerHTML
        return

    codeverificationContent.classList.add("error")
    userFeedback.innerHTML = "Unexptected Error occured!"
    return

############################################################
resetAllErrorFeedback = ->
    log "resetAllErrorFeedback"
    codeverificationContent.classList.remove("error")
    codeverificationBirthdayInput.classList.remove("error")
    userFeedback.innerHTML = ""
    return

############################################################
export pickUpConfirmedCredentials = (givenCode) ->
    log "pickUpConfirmedCredentials"
    code = givenCode
    return modalCore.modalPromise

############################################################
export turnUpModal =  ->
    log "turnUpModal"
    modalCore.activate()
    return

############################################################
export turnDownModal = (reason) ->
    log "turnDownModal"
    modalCore.reject(reason)
    return