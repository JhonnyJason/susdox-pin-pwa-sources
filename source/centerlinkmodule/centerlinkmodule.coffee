############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("centerlinkmodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import *  as utl from "./utilmodule.js"

############################################################
susdoxLink = document.getElementById("susdox-link")

############################################################
export initialize = ->
    log "initialize"
    susdoxLink.addEventListener("click", susdoxLinkClicked)
    return

############################################################
susdoxLinkClicked = (evnt) ->
    log "susdoxLinkClicked"
    evnt.preventDefault()
    credentials = S.load("userCredentials")
    if credentials? and Object.keys(credentials).length > 0 
        try
            loginBody = utl.loginRequestBody(credentials)
            response = await sci.loginWithRedirect(loginBody)

            if !response.ok then throw new Error("Unexpected StatusCode: #{response.status}\n#{await response.text()}")
            
            return
        catch err then log err
    window.open(susdoxLink.getAttribute("href"), "_blank")
    return

