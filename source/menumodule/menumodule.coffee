############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("menumodule")
#endregion

############################################################
import M from "mustache"

############################################################
import * as app from "./appcoremodule.js"
import * as accountModule from "./accountmodule.js"

############################################################
#region DOM Cache
menuFrame = document.getElementById("menu-frame")
menuAddCode = document.getElementById("menu-add-code")
menuLogout = document.getElementById("menu-logout")
menuVersion = document.getElementById("menu-version")
allUsers = document.getElementById("all-users")
menuEntryTemplate =  document.getElementById("menu-entry-template")

#endregion

############################################################
entryTemplate = menuEntryTemplate.innerHTML

############################################################
export initialize = ->
    log "initialize"
    menuFrame.addEventListener("click", menuFrameClicked)
    menuAddCode.addEventListener("click", addCodeClicked)
    menuLogout.addEventListener("click", logoutClicked)
    menuVersion.addEventListener("click", menuVersionClicked)
    return

############################################################
#region event Listeners
menuFrameClicked = (evnt) ->
    log "menuFrameClicked"
    app.triggerMenu()
    return

userEntryClicked = (evnt) ->
    log "userEntryClicked"
    evnt.stopPropagation()
    el = evnt.currentTarget
    userIndex = el.getAttribute("user-index")
    log userIndex
    {activeAccount} = accountModule.getAccountsInfo()
    userIndex = parseInt(userIndex)

    if userIndex == activeAccount then app.triggerHome()

    accountModule.setAccountActive(userIndex) unless userIndex == NaN
    return

addCodeClicked = (evnt) ->
    log "addCodeClicked"
    evnt.stopPropagation()
    app.triggerAddCode()
    return


logoutClicked = (evnt) ->
    log "logoutClicked"
    evnt.stopPropagation()
    app.triggerLogout()
    return

menuVersionClicked = (evnt) ->
    log "menuVersionClicked"
    evnt.stopPropagation()
    app.triggerUpgrade()
    return

#endregion

############################################################
export updateAllUsers = ->
    log "updateAllUsers"
    {activeAccount, allAccounts, accountValidity} = accountModule.getAccountsInfo()
    
    html = ""
    for accountObj,idx in allAccounts
        log "#{idx}:#{accountObj.label}"
        cObj = {}
        cObj.userLabel = accountObj.label
        cObj.index = idx
        html += M.render(entryTemplate, cObj)

    allUsers.innerHTML = html
    
    if allAccounts.length == 0 then menu.classList.add("no-user")
    else menu.classList.remove("no-user")
    
    activeUser = document.querySelector(".menu-entry[user-index='#{activeAccount}']")
    if activeUser? then activeUser.classList.add("active-user")

    allUserEntries = document.querySelectorAll("#all-users > *")
    for userEntry,idx in allUserEntries
        log "userEntry: #{idx}:#{userEntry.getAttribute("user-index")}"
        userEntry.addEventListener("click", userEntryClicked)
    return

############################################################
#region UI State functions

############################################################
export setMenuOff = ->
    document.body.classList.remove("menu-on")
    return

############################################################
export setMenuOn = ->
    document.body.classList.add("menu-on")
    return

#endregion