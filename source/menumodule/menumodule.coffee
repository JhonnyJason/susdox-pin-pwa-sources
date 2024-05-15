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
import * as pwaInstall from "./pwainstallmodule.js"
import * as triggers from "./navtriggers.js"

############################################################
#region DOM Cache
menuFrame = document.getElementById("menu-frame")
menuAddCode = document.getElementById("menu-add-code")
menuLogout = document.getElementById("menu-logout")
menuVersion = document.getElementById("menu-version")
menuPWAInstallButton = document.getElementById("menu-pwa-install-button")
allUsers = document.getElementById("all-users")
menuEntryTemplate =  document.getElementById("menu-entry-template")
unnamedTextElement = document.getElementById("unnamed-text-element")

#endregion

############################################################
entryTemplate = menuEntryTemplate.innerHTML
unnamedText = unnamedTextElement.textContent

############################################################
export initialize = ->
    log "initialize"
    menuFrame.addEventListener("click", menuFrameClicked)
    menuAddCode.addEventListener("click", addCodeClicked)
    menuLogout.addEventListener("click", logoutClicked)
    menuVersion.addEventListener("click", menuVersionClicked)
    menuPWAInstallButton.addEventListener("click", pwaInstallClicked)
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

    if userIndex == activeAccount then triggers.home()

    accountModule.setAccountActive(userIndex) unless userIndex == NaN
    return

addCodeClicked = (evnt) ->
    log "addCodeClicked"
    evnt.stopPropagation()
    triggers.addCode()
    return

logoutClicked = (evnt) ->
    log "logoutClicked"
    evnt.stopPropagation()
    triggers.logout()
    return

menuVersionClicked = (evnt) ->
    log "menuVersionClicked"
    evnt.stopPropagation()
    triggers.reload()
    return

pwaInstallClicked = (evnt) ->
    log "pwaInstallClicked"
    pwaInstall.promptForInstallation()
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
        defaultLabel = accountObj.name || unnamedText
        if accountObj.label == "" then cObj.userLabel = defaultLabel
        else cObj.userLabel = accountObj.label
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

############################################################
export setInstallableOn =  ->
    document.body.classList.add("installable")

############################################################
export setInstallableOff = ->
    document.body.classList.remove("installable")

#endregion