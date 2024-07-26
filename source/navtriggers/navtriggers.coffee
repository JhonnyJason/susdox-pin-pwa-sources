############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("navtriggers")
#endregion

############################################################
import * as nav from "navhandler"

############################################################
import * as S from "./statemodule.js"
# import {setSustSolLogo} from "./radiologistdatamodule.js"
import {setQRCode} from "./radiologistdatamodule.js"

############################################################
## Navigation Action Triggers

############################################################
export home = ->
    navState = S.get("navState")
    # if navState.depth == 0 then setSustSolLogo()
    if navState.depth == 0 then setQRCode()
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
    return await nav.toBaseAt("add-code", null, 1)

############################################################
export codeUpdate = ->
    return await nav.toBaseAt("update-code", null, 1)

############################################################
export requestCode = ->
    return await nav.toBase("request-code")

############################################################
export requestUpdateCode = ->
    return await nav.toBase("request-update-code")

############################################################
export codeReveal = (toReveal) ->
    if toReveal then return nav.toMod("coderevealed")
    else return nav.toMod("none")

############################################################
export invalidCode = ->
    return nav.toMod("invalidcode")

############################################################
export screeningsList = ->
    return nav.toBase("screenings-list")

############################################################
export reload = ->
    window.location.reload()
    return
