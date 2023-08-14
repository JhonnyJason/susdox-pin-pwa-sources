############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("usernamedisplaymodule")
#endregion

############################################################
import * as account from "./accountmodule.js"

############################################################
# DOM Cache
usernamedisplayContainer = document.getElementById("usernamedisplay-container")
usernamedisplay = document.getElementById("usernamedisplay")
usernameEditButton = document.getElementById("username-edit-button")

############################################################
export initialize = ->
    log "initialize"
    usernameEditButton.addEventListener("click", editButtonClicked)
    return

############################################################
editButtonClicked = (evnt) ->
    log "editButtonClicked"
    ## TODO implement
    return

############################################################
setUsername = (name) ->
    log "setUsername"
    usernamedisplay.textContent = name
    return

############################################################
export updateUsername = ->
    log "updateUsername"
    try 
        accountObj = account.getAccountObject()
        usernamedisplayContainer.classList.remove("no-username")
        setUsername(accountObj.label)
        return

    catch err then log err
    
    #this is still the error case    
    usernamedisplayContainer.classList.add("no-username")
    setUsername("")
    return

