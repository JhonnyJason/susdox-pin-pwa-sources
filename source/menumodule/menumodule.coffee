############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("menumodule")
#endregion

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

############################################################
export setMenuOff = ->
    document.body.classList.remove("menu-on")
    return

############################################################
export setMenuOn = ->
    document.body.classList.add("menu-on")
    return
