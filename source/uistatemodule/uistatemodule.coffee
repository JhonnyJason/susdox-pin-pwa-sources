############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("uistatemodule")
#endregion

############################################################
import * as S from "./statemodule.js"

############################################################
#region imported UI modules
import * as content from "./contentmodule.js"
import * as menu from "./menumodule.js"
import * as codeverificationModal from "./codeverificationmodal.js"
import * as logoutModal from "./logoutmodal.js"
import * as invalidcodeModal from "./invalidcodemodal.js"

#endregion

############################################################
applyState = {}

############################################################
export initialize = ->
    log "initialize"
    S.addOnChangeListener("uiState", applyUIState)
    return

############################################################
applyUIState = ->
    log "applyUIState"
    uiState = S.get("uiState")
    applyFunction = applyState[uiState]
    if typeof applyFunction == "function" then return applyFunction()
         
    # log "on applyUIState: uiState '#{uiState}' did not have an apply function!"
    throw new Error("on applyUIState: uiState '#{uiState}' did not have an apply function!")
    return

############################################################
#region applyState functions

############################################################
#region no-code states
applyState["no-code:none"] = ->
    content.setToDefaultState()
    menu.setMenuOff()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    return

applyState["no-code:menu"] = ->
    content.setToDefaultState()
    menu.setMenuOn()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    return

applyState["add-first-code:none"] = ->
    content.setToAddCodeState()
    menu.setMenuOff()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    return

applyState["add-first-code:menu"] = ->
    content.setToAddCodeState()
    menu.setMenuOn()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    return

#endregion

############################################################
#region user states
applyState["pre-user-images:none"] = ->
    content.setToPreUserImagesState()
    menu.setMenuOff()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")

    return

applyState["pre-user-images:menu"] = ->
    content.setToPreUserImagesState()
    menu.setMenuOn()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    return

applyState["user-images:none"] = ->
    content.setToUserImagesState()    
    menu.setMenuOff()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    return

applyState["user-images:menu"] = ->
    content.setToUserImagesState()    
    menu.setMenuOn()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    return




#endregion

#endregion