############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import * as credentialsframe from "./credentialsframemodule.js"
import * as radiologistImages from "./radiologistimagemodule.js"
import * as codeDisplay from "./codedisplaymodule.js"
import * as menuModule from "./menumodule.js"

############################################################
menuFrame = document.getElementById("menu-frame")

############################################################
export initialize = ->
    log "initialize"
    menuFrame.addEventListener("click", menuFrameClicked)
    return


############################################################
menuFrameClicked = (evnt) ->
    log "menuFrameClicked"
    menuModule.setMenuOff()
    return

############################################################
export setToDefault = ->
    log "setToDefault"
    content.classList.remove("preload")
    content.classList.remove("setting-credentials")
    content.classList.remove("credentials-set")
    
    menuModule.setMenuOff()

    ## TODO remove rest
    # content.classList.remove("")
    
    return

############################################################
export setToUserPage = ->
    log "setToUserPage"
    content.classList.remove("preload")
    content.classList.remove("setting-credentials")
    content.classList.add("credentials-set")
    
    ## actually unnecessary here but for completeness sake ;-)
    menuModule.setMenuOff()

    ## TODO adjust rest
    # content.classList.remove("")
    # content.classList.add("")
    
    return