############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("menumodule")
#endregion

############################################################
import * as app from "./appcoremodule.js"
import * as modal from "./usermodalmodule.js"

############################################################
export initialize = ->
    log "initialize"
    menuMoreInfo.addEventListener("click", moreInfoClicked)
    menuLogout.addEventListener("click", logoutClicked)
    menuVersion.addEventListener("click", menuVersionClicked)
    return

############################################################
#region event Listeners
moreInfoClicked = (evnt) ->
    log "moreInfoClicked"
    app.moreInfo()
    return

logoutClicked = (evnt) ->
    log "logoutClicked"
    try
        await modal.userLogoutConfirm()
        app.logout()
    catch err then log "User rejected logout!"
    return

menuVersionClicked = (evnt) ->
    log "menuVersionClicked"
    app.upgrade()
    return

#endregion

############################################################
export setMenuOff = ->
    document.body.classList.remove("menu-on")
    return

############################################################
export setMenuOn = ->
    document.body.classList.add("menu-on")
    return
