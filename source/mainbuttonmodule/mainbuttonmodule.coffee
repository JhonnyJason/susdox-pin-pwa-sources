############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("mainbuttonmodule")
#endregion

############################################################
import * as codeDisplay from "./codedisplaymodule.js"
import * as credentialsframe from "./credentialsframemodule.js"
import * as contentModule from "./contentmodule.js"

############################################################
addCodeButton = document.getElementById("add-code-button")
acceptButton = document.getElementById("accept-button")
codeButton = document.getElementById("code-button")

############################################################
rejectAcceptPromise = null
resolveAcceptPromise = null

############################################################
export initialize = ->
    log "initialize"
    addCodeButton.addEventListener("click", addCodeButtonClicked)
    acceptButton.addEventListener("click", acceptButtonClicked)

    codeButton.addEventListener("click", codeButtonClicked)
    return

############################################################
clearPromise = ->
    log "clearPromise"
    rejectAcceptPromise = null
    resolveAcceptPromise = null
    return


############################################################
addCodeButtonClicked = (evnt) ->
    log "addCodeButtonClicked"
    contentModule.setToAddCodeState()
    return

############################################################
codeButtonClicked = (evnt) ->
    # codeDisplay.revealOrCopy()
    codeDisplay.revealOrHide()
    return

############################################################
export acceptButtonClicked = (evnt) ->
    log "acceptButtonClicked"
    acceptButton.classList.add("disabled")
    try
        if !credentialsframe.makeAcceptable() then return
        credentialsframe.resetAllErrorFeedback()
        # await utl.waitMS(5000)
        await credentialsframe.extractCredentials()
        if resolveAcceptPromise? then resolveAcceptPromise()
        else contentModule.setToUserImagesState()
        
    catch err
        log err
        credentialsframe.errorFeedback(err)
    finally
        acceptButton.classList.remove("disabled")
    return

############################################################
export waitToAccept = ->
    log "waitToAccept"
    
    acceptPromise = new Promise (resolve, reject) ->
        rejectAcceptPromise = ->
            reject()
            clearPromise()
            return

        resolveAcceptPromise = ->
            resolve()
            clearPromise()
            return
            
    return acceptPromise

export cancelAcceptWait = ->
    log "cancelAcceptWait"
    if rejectAcceptPromise? then rejectAcceptPromise()
    return
