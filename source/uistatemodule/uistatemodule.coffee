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

#endregion

############################################################
applyBaseState = {}
applyModifier = {}

############################################################
currentBase = null
currentModifier = null
currentContext = null

############################################################
#region Base State Application Functions

applyBaseState["no-code"] = (ctx) ->
    content.setToDefaultState(ctx)
    return

applyBaseState["add-code"] = (ctx) ->
    content.setToAddCodeState(ctx)
    return

applyBaseState["update-code"] = (ctx) ->
    content.setToUpdateCodeState(ctx)
    return

applyBaseState["request-code"] = (ctx) ->
    content.setToRequestCodeState(ctx)
    return

applyBaseState["request-update-code"] = (ctx) ->
    content.setToRequestUpdateCodeState(ctx)
    return

applyBaseState["pre-user-images"] = (ctx) ->
    content.setToPreUserImagesState(ctx)
    return

applyBaseState["user-images"] = (ctx) ->
    content.setToUserImagesState(ctx)    
    return

applyBaseState["screenings-list"] = (ctx) ->
    content.showScreeningsList(ctx)
    return


#endregion

############################################################
resetAllModifications = ->
    menu.setMenuOff()
    codeDisplay.hideCode()
    codeverificationModal.turnDownModal("uiState changed")
    logoutModal.turnDownModal("uiState changed")
    invalidcodeModal.turnDownModal("uiState changed")
    return

############################################################
#region Modifier State Application Functions

applyModifier["none"] = (ctx) ->
    resetAllModifications()
    return

applyModifier["menu"] = (ctx) ->
    resetAllModifications()
    menu.setMenuOn()
    return

applyModifier["codeverification"] = (ctx) ->
    resetAllModifications(ctx)
    codeverificationModal.turnUpModal()
    return

applyModifier["logoutconfirmation"] = (ctx) ->
    resetAllModifications()
    logoutModal.turnUpModal()
    return

applyModifier["invalidcode"] = (ctx) ->
    resetAllModifications()
    invalidcodeModal.turnUpModal()
    return

applyModifier["coderevealed"] = (ctx) ->
    resetAllModifications()
    codeDisplay.revealCode()
    return

#endregion


############################################################
#region exported general Application Functions
export applyUIState = (base, modifier, ctx) ->
    log "applyUIState"
    currentContext = ctx

    if base? then applyUIStateBase(base)
    if modifier? then applyUIStateModifier(modifier)
    return

############################################################
export applyUIStateBase = (base) ->
    log "applyUIBaseState #{base}"
    applyBaseFunction = applyBaseState[base]

    if typeof applyBaseFunction != "function" then throw new Error("on applyUIStateBase: base '#{base}' apply function did not exist!")

    currentBase = base
    applyBaseFunction(currentContext)
    return

############################################################
export applyUIStateModifier = (modifier) ->
    log "applyUIStateModifier #{modifier}"
    applyModifierFunction = applyModifier[modifier]

    if typeof applyUIStateModifier != "function" then throw new Error("on applyUIStateModifier: modifier '#{modifier}' apply function did not exist!")

    currentModifier = modifier
    applyModifierFunction(currentContext)
    return

############################################################
export getModifier = -> currentModifier
export getBase = -> currentBase
export getContext = -> currentContext

#endregion