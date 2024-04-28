############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("uistatemodule")
#endregion

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
applyBaseState = {}
applyModifier = {}

############################################################
#region Base State Application Functions

applyBaseState["no-code"] = ->
    content.setToDefaultState()
    return

applyBaseState["add-code"] = ->
    content.setToAddCodeState()
    return

applyBaseState["pre-user-images"] = ->
    content.setToPreUserImagesState()
    return

applyBaseState["user-images"] = ->
    content.setToUserImagesState()    
    return

#endregion

############################################################
resetAllModifications = ->
    menu.setMenuOff()
    screeningsList.hide()
    codeDisplay.hideCode()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    credentialsFrame.prepareForAddCode()
    credentialsFrame.resetAllErrorFeedback()
    return

############################################################
#region Modifier State Application Functions

applyModifier["none"] = ->
    resetAllModifications()
    return

applyModifier["menu"] = ->
    resetAllModifications()
    menu.setMenuOn()
    return

applyModifier["codeverification"] = ->
    resetAllModifications()
    codeverificationModal.turnUpModal()
    return

applyModifier["logoutconfirmation"] = ->
    resetAllModifications()
    logoutModal.turnUpModal()
    return

applyModifier["invalidcode"] = ->
    resetAllModifications()
    invalidcodeModal.turnUpModal()
    return

applyModifier["updatecode"] = ->
    resetAllModifications()
    content.setToAddCodeState()
    return

applyModifier["coderevealed"] = ->
    resetAllModifications()
    codeDisplay.revealCode()
    return

applyModifier["screeningslist"] = ->
    resetAllModifications()
    screeningsList.show()
    return

#endregion


############################################################
#region exported general Application Functions
export applyUIState = (base, modifier) ->
    log "applyUIState"
    if base? then applyUIStateBase(base)
    if modifier? then applyUIStateModifier(modifier)
    return

############################################################
export applyUIStateBase = (base) ->
    log "applyUIBaseState #{base}"
    applyBaseFunction = applyBaseState[base]

    if typeof applyBaseFunction != "function" then throw new Error("on applyUIStateBase: base '#{base}' apply function did not exist!")

    applyBaseFunction()
    return

############################################################
export applyUIStateModifier = (modifier) ->
    log "applyUIStateModifier #{modifier}"
    applyModifierFunction = applyModifier[modifier]

    if typeof applyUIStateModifier != "function" then throw new Error("on applyUIStateModifier: modifier '#{modifier}' apply function did not exist!")

    applyModifierFunction()
    return

#endregion