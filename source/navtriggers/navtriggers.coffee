############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("navtriggers")
#endregion

############################################################
import * as nav from "navhandler"

############################################################
import * as S from "./statemodule.js"
import {setSustSolLogo} from "./radiologistdatamodule.js"

############################################################
## Navigation Action Triggers

############################################################
export home = ->
    navState = S.get("navState")
    if navState.depth == 0 then setSustSolLogo()
    else return nav.toRoot(true)
    
############################################################
export menu = (menuOn) ->
    if menuOn then return nav.toMod("menu")
    else return nav.toMod("none")
 
############################################################
export logout = ->
    return nav.toMod("logoutconfirmation")

############################################################
export addCode = ->
    return await nav.toBase("AddCode")

############################################################
export codeUpdate = ->
    return await nav.toMod("updatecode")

############################################################
export requestCode = ->
    return await nav.toBase("request-code")

############################################################
export codeReveal = (toReveal) ->
    if toReveal then return nav.toMod("coderevealed")
    else return nav.toMod("none")

############################################################
export screeningsList = ->
    return nav.toBase("screeningslist")

############################################################
export reload = ->
    window.location.reload()
    return
