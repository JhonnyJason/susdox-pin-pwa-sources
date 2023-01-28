############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

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
    content.classList.remove("login")
    return


############################################################
export setToUserPage = ->
    log "setToUserPage"
    ## TODO implement
    return