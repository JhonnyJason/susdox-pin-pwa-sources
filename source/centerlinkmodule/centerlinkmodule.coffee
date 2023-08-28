############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("centerlinkmodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import *  as utl from "./utilmodule.js"

############################################################
centerlink = document.getElementById("centerlink")
susdoxLink = document.getElementById("susdox-link")
dateOfBirthDisplay = document.getElementById("date-of-birth-display")

############################################################
export initialize = ->
    ## prod log "initialize"
    susdoxLink.addEventListener("click", susdoxLinkClicked)
    return

############################################################
susdoxLinkClicked = (evnt) ->
    ## prod log "susdoxLinkClicked"
    evnt.preventDefault()
    credentials = S.load("userCredentials")
    if credentials? and Object.keys(credentials).length > 0 
        try
            loginBody = utl.loginRequestBody(credentials)
            response = await sci.loginWithRedirect(loginBody)
            ## prod log "#{await response.text()}"
            
            return
        catch err then log err
    window.open(susdoxLink.getAttribute("href"), "_blank")
    return

############################################################
export updateDateOfBirth = (dateOfBirth) ->
    ## prod log "updateDateOfBirth"
    tokens = dateOfBirth.split("-")
    
    if tokens.length == 3
        year = tokens[0]
        month = tokens[1]
        day = tokens[2]

        dateOfBirth = "#{day}.#{month}.#{year}"

    dateOfBirthDisplay.textContent = dateOfBirth
    return

############################################################
export displayDateOfBirth = ->
    ## prod log "displayDateOfBirth"
    centerlink.classList.add("code-shown")
    return

export displayCenterLink = ->
    ## prod log "displayCenterLink"
    centerlink.classList.remove("code-shown")
    return
