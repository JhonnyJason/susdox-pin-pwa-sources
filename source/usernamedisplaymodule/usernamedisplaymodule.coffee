############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("usernamedisplaymodule")
#endregion

############################################################
import * as account from "./accountmodule.js"
import * as menu from "./menumodule.js"

############################################################
# DOM Cache
usernamedisplayContainer = document.getElementById("usernamedisplay-container")
usernamedisplay = document.getElementById("usernamedisplay")
usernameEditButton = document.getElementById("username-edit-button")

############################################################
currentUsername = ""

############################################################
export initialize = ->
    log "initialize"
    usernameEditButton.addEventListener("click", editButtonClicked)
    usernamedisplay.addEventListener("keydown", usernamedisplayKeyDowned)
    usernamedisplay.addEventListener("blur", usernamedisplayBlurred)
    return

############################################################
stopEditing = ->
    setUsername(currentUsername)
    usernamedisplay.removeAttribute("contenteditable")
    window.getSelection().removeAllRanges()
    return

############################################################
applyUsername = (name) ->
    log "applyUsername"
    return if currentUsername == name

    currentUsername = name
    account.saveLabelEdit(name)
    menu.updateAllUsers()
    return

############################################################
usernamedisplayBlurred = (evnt) ->
    log "usernamedisplayBlurred"
    applyUsername(usernamedisplay.textContent)
    stopEditing()
    return


############################################################
usernamedisplayKeyDowned = (evnt) ->
    log "usernamedisplayKeyDowned"
    
    # 13 is enter
    if evnt.keyCode == 13
        evnt.preventDefault()
        applyUsername(usernamedisplay.textContent)
        stopEditing()
    
    # 27 is escape
    if evnt.keyCode == 27 then stopEditing()
    return

############################################################
editButtonClicked = (evnt) ->
    log "editButtonClicked"
    usernamedisplay.setAttribute("contenteditable", true)
    window.getSelection().selectAllChildren(usernamedisplay)
    return

############################################################
setUsername = (name) ->
    log "setUsername"
    currentUsername = name
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

