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
export initialize = ->
    log "initialize"
    addCodeButton.addEventListener("click", addCodeButtonClicked)
    acceptButton.addEventListener("click", acceptButtonClicked)

    codeButton.addEventListener("click", codeButtonClicked)
    return


############################################################
addCodeButtonClicked = (evnt) ->
    log "addCodeButtonClicked"
    contentModule.setToLoginPage()
    return

############################################################
acceptButtonClicked = (evnt) ->
    log "acceptButtonClicked"
    acceptButton.classList.add("disabled")
    try 
        credentialsframe.resetAllErrorFeedback()
        # await utl.waitMS(5000)
        await credentialsframe.extractCredentials()
        contentModule.setToUserPage()
        
    catch err 
        log err
        credentialsframe.errorFeedback(err)
    finally 
        acceptButton.classList.remove("disabled")
    return

############################################################
codeButtonClicked = (evnt) ->
    # codeDisplay.revealOrCopy()
    codeDisplay.revealOrHide()
    return

