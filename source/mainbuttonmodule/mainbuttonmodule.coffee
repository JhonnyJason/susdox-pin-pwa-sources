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
    content.classList.add("setting-credentials")
    return

############################################################
acceptButtonClicked = (evnt) ->
    log "acceptButtonClicked"
    try 
        credentialsframe.extractCredentials()
        contentModule.setToUserPage()
        
        # await utl.waitMS(5000)
        # credentialsframe.resetAllErrorFeedback()
       
        # loginBody = await extractCodeFormBody()
        # olog {loginBody}

        # if !loginBody.hashedPw and !loginBody.username then return

        # response = await doLoginRequest(loginBody)
        
        # if !response.ok then errorFeedback("codePatient", ""+response.status)
        # else location.href = loginRedirectURL

    catch err then return credentialsframe.errorFeedback("codePatient", "Other: " + err.message)
    return

############################################################
codeButtonClicked = (evnt) ->
    codeDisplay.revealOrCopy()
    return

