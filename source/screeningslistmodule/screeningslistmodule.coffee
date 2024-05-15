############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("screeningslistmodule")
#endregion

############################################################
import M from "mustache"
import * as utl from "./utilmodule.js"

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
    credentials = await utl.hashedCredentials(credentials)
    screeningsObj = await sci.getScreenings(credentials)
    # body = await utl.loginRequestBody(credentials)
    # resp = await sci.loginRequest(body)
    # screeningsObj = {}
    result = []
    result.push obj for label,obj of screeningsObj
    return result

############################################################
screeningClicked = (evnt) ->
    log "screeningClicked"
    evnt.preventDefault()
    href = this.getAttribute("href")
    window.open(href)
    return

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

        ## attach event listener fo link clicks
        btns = screeningslist.getElementsByClassName("screening-button")
        btn.addEventListener("click", screeningClicked) for btn in btns

    catch err
        log err
        if err instanceof AuthenticationError 
            screeningslist.innerHTML = authErrorScreeningsTemplate
            return
        if err instanceof NetworkError
            screeningslist.innerHTML = networkErrorScreeningsTemplate
            ## TODO remove only for fixing the iOS bug
            errorDetailsHTML = "<div class='screenings-error'>#{err.message}</div>"
            screeningslist.innerHTML = errorDetailsHTML
            return
        screeningslist.innerHTML = miscErrorScreeningsTemplate
        ## TODO remove only for fixing the iOS bug
        errorDetailsHTML = "<div class='screenings-error'>#{err.message}</div>"
        screeningslist.innerHTML = errorDetailsHTML
    finally screeningsContainer.classList.remove("preload")
    return

############################################################
export show = -> realBody.classList.add("list-screenings")
export hide = -> realBody.classList.remove("list-screenings")


