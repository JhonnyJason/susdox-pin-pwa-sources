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
savedPlaceholder = ""

############################################################
export initialize = ->
    log "initialize"
    # usernameEditButton.addEventListener("click", editButtonClicked)
    usernamedisplay.addEventListener("keydown", usernamedisplayKeyDowned)
    # usernamedisplay.addEventListener("blur", usernamedisplayBlurred)
    usernamedisplay.addEventListener("change", usernamedisplayBlurred)
    savedPlaceholder = usernamedisplay.getAttribute("placeholder") 
    return

############################################################
stopEditing = ->
    setUsername(currentUsername)
    usernamedisplay.blur()
    # usernamedisplay.removeAttribute("contenteditable")
    # window.getSelection().removeAllRanges()
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
    applyUsername(usernamedisplay.value)
    stopEditing()
    return


############################################################
usernamedisplayKeyDowned = (evnt) ->
    log "usernamedisplayKeyDowned"
    
    # 13 is enter
    if evnt.keyCode == 13
        evnt.preventDefault()
        applyUsername(usernamedisplay.value)
        stopEditing()
    
    # 27 is escape
    if evnt.keyCode == 27 then stopEditing()
    return

############################################################
editButtonClicked = (evnt) ->
    log "editButtonClicked"
    # usernamedisplay.setAttribute("contenteditable", true)
    # window.getSelection().selectAllChildren(usernamedisplay)
    return

############################################################
setUsername = (name) ->
    log "setUsername"
    currentUsername = name
    usernamedisplay.value = name
    return

setDefaultName = (defaultName) ->
    log "setDefaultName"
    if defaultName? then usernamedisplay.setAttribute("placeholder", defaultName)
    else usernamedisplay.setAttribute("placeholder", savedPlaceholder)
    return

############################################################
export updateUsername = ->
    log "updateUsername"
    try
        accountObj = account.getAccountObject()
        usernamedisplayContainer.classList.remove("no-username")
        setDefaultName(accountObj.name)
        setUsername(accountObj.label)
        return

    catch err 
        log err
        usernamedisplayContainer.classList.add("no-username")
        setDefaultName()
        setUsername("")
    return

