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
import * as codeDisplay from "./codedisplaymodule.js"
import * as credentialsFrame from "./credentialsframemodule.js"
import * as codeverificationModal from "./codeverificationmodal.js"
import * as logoutModal from "./logoutmodal.js"
import * as invalidcodeModal from "./invalidcodemodal.js"
import * as screeningsList from "./screeningslistmodule.js"

#endregion

############################################################
applyState = {}

############################################################
export initialize = ->
    ## prod log "initialize"
    S.addOnChangeListener("uiState", applyUIState)
    return

############################################################
applyUIState = ->
    ## prod log "applyUIState"
    uiState = S.get("uiState")
    applyFunction = applyState[uiState]
    if typeof applyFunction == "function" then return applyFunction()
         
    # ## prod log "on applyUIState: uiState '#{uiState}' did not have an apply function!"
    throw new Error("on applyUIState: uiState '#{uiState}' did not have an apply function!")
    return

############################################################
resetAllModifications = ->
    menu.setMenuOff()
    screeningsList.hide()
    codeDisplay.hideCode()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    credentialsFrame.resetAllErrorFeedback()
    return

############################################################
#region applyState functions

############################################################
#region no-code states
applyState["no-code:none"] = ->
    content.setToDefaultState()
    menu.setMenuOff()
    codeDisplay.hideCode()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    credentialsFrame.resetAllErrorFeedback()
    return

applyState["no-code:menu"] = ->
    content.setToDefaultState()
    menu.setMenuOn()
    codeDisplay.hideCode()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    credentialsFrame.resetAllErrorFeedback()
    return

applyState["no-code:codeverification"] = ->
    content.setToDefaultState()
    codeverificationModal.turnUpModal()
    menu.setMenuOff()
    codeDisplay.hideCode()
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    credentialsFrame.resetAllErrorFeedback()
    return

#endregion

############################################################
#region add-code states
applyState["add-code:none"] = ->
    credentialsFrame.prepareForAddCode()
    resetAllModifications()
    return

applyState["add-code:menu"] = ->
    content.setToAddCodeState()
    resetAllModifications()
    menu.setMenuOn()
    return

applyState["add-code:logoutconfirmation"] = ->
    content.setToAddCodeState()
    resetAllModifications()
    logoutModal.turnUpModal()
    return

#endregion

applyState["pre-user-images:none"] = ->
    content.setToPreUserImagesState()
    resetAllModifications()
    return

############################################################
#region user-images states
applyState["user-images:none"] = ->
    content.setToUserImagesState()    
    resetAllModifications()
    return

applyState["user-images:codeverification"] = ->
    content.setToUserImagesState()
    resetAllModifications()
    codeverificationModal.turnUpModal()
    return

applyState["user-images:menu"] = ->
    content.setToUserImagesState()    
    resetAllModifications()
    menu.setMenuOn()
    return

applyState["user-images:logoutconfirmation"] = ->
    content.setToUserImagesState()    
    resetAllModifications()
    logoutModal.turnUpModal()
    return

applyState["user-images:invalidcode"] = ->
    content.setToUserImagesState()    
    resetAllModifications()
    invalidcodeModal.turnUpModal()
    return

applyState["user-images:updatecode"] = ->
    credentialsFrame.prepareForCodeUpdate()
    resetAllModifications()
    content.setToAddCodeState()
    return

applyState["user-images:coderevealed"] = ->
    content.setToUserImagesState()    
    resetAllModifications()
    codeDisplay.revealCode()
    return

applyState["user-images:screeningslist"] = ->
    content.setToUserImagesState()    
    resetAllModifications()
    screeningsList.show()
    return

#endregion

#endregion