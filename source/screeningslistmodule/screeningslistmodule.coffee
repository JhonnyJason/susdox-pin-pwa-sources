############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("screeningslistmodule")
#endregion

############################################################
import M from "mustache"
import { waitMS } from "./utilmodule.js"

import {NetworkError, AuthenticationError} from "./errormodule.js"

import * as sci from "./scimodule.js"
import * as account from "./accountmodule.js"


############################################################
dateStringOptions = {
    year: "numeric"
    month: "numeric"
    day: "numeric"
}

############################################################
realBody = document.getElementById("real-body")
screeningsContainer = document.getElementById("screenings-container")

screeningButtonTemplate = document.getElementById("screening-button-template").innerHTML
noScreeningsTemplate = document.getElementById("no-screenings-template").innerHTML
networkErrorScreeningsTemplate = document.getElementById("network-error-screenings-template").innerHTML
authErrorScreeningsTemplate = document.getElementById("auth-error-screenings-template").innerHTML
miscErrorScreeningsTemplate = document.getElementById("misc-error-screenings-template").innerHTML

# """
# <a class="click-button screening-button" href="{{{url}}}>
#     <div class="screening-description">{{{description}}}
#     <svg><use href="#svg-chevron-right-icon"/></svg>
#     </div>
#     <div class="screening-date">{{{date}}}</div>
# </a>
# """

############################################################
export initialize = ->
    log "initialize"
    log screeningButtonTemplate
    screeningslist.innerHTML = noScreeningsTemplate
    # screeningslist.innerHTML = authErrorScreeningsTemplate
    # updateScreenings()
    return

############################################################
retrieveScreenings = ->
    log "retrieveScreenings"
    credentials = account.getUserCredentials()
    screeningsObj = await sci.getScreenings(credentials)
    result = []
    result.push obj for label,obj of screeningsObj
    return result

############################################################
export updateScreenings = ->
    log "updateScreenings"

    try 
        screeningsContainer.classList.add("preload")
        screenings = await retrieveScreenings()
        # olog screenings

        if screenings.length <= 0
            screeningslist.innerHTML = noScreeningsTemplate
            return

        html = ""
        for screening in screenings
            date = new Date(screening.date)
            screening.date = date.toLocaleDateString("de-DE", dateStringOptions)
            html += M.render(screeningButtonTemplate, screening)

        screeningslist.innerHTML = html
    catch err
        log err
        if err instanceof AuthenticationError 
            screeningslist.innerHTML = authErrorScreeningsTemplate
            return
        if err instanceof NetworkError
            screeningslist.innerHTML = networkErrorScreeningsTemplate
            return
        screeningslist.innerHTML = miscErrorScreeningsTemplate
    finally screeningsContainer.classList.remove("preload")
    return

############################################################
export show = -> realBody.classList.add("list-screenings")
export hide = -> realBody.classList.remove("list-screenings")


