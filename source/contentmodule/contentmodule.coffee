############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import * as loginFrame from "./loginframemodule.js"
############################################################
export initialize = ->
    log "initialize"
    addCodeButton.addEventListener("click", addCodeButtonClicked)
    loginButton.addEventListener("click", loginButtonClicked)

    return

############################################################
addCodeButtonClicked = (evnt) ->
    log "addCodeButtonClicked"
    content.classList.add("login")
    return

############################################################
loginButtonClicked = (evnt) ->
    log "loginButtonClicked"
    content.classList.add("logging-in")
    try
        await utl.waitMS(5000)
        # loginFrame.resetAllErrorFeedback()
       
        # loginBody = await extractCodeFormBody()
        # olog {loginBody}

        # if !loginBody.hashedPw and !loginBody.username then return

        # response = await doLoginRequest(loginBody)
        
        # if !response.ok then errorFeedback("codePatient", ""+response.status)
        # else location.href = loginRedirectURL

    catch err then return loginFrame.errorFeedback("codePatient", "Other: " + err.message)
    finally content.classList.remove("logging-in")
    return



############################################################
export setToUserPage = ->
    log "setToUserPage"
    ## TODO implement
    return