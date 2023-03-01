############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("centerlinkmodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import *  as utl from "./utilmodule.js"
import { loginURL } from "./configmodule.js"

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
            loginBody = getLoginBody(credentials)
            await doLoginRequest(loginBody)
            return
        catch err then log err
    return
    # window.location = susdoxLink.getAttribute("href")
    # return

############################################################
getLoginBody = (credentials) ->
    log "getLoginBody"

    { dateOfBirth, code } = credentials
    username = ""+dateOfBirth

    if !utl.isAlphanumericString(code) then throw new Error("Credentials contained invalid code!")
    # if !utl.isBase32String(code) then throw new Error("Credentials contained invalid code!")

    isMedic = false
    rememberMe = false

    hashedPw = utl.argon2HashPw(code, username)

    return {username, hashedPw, isMedic, rememberMe}


############################################################
doLoginRequest = (body) ->
    log "doLoginRequest"
    method = "POST"
    mode = 'cors'
    redirect =  'follow'
    credentials = 'include'
    
    # json body
    headers = { 'Content-Type': 'application/json' }
    body = JSON.stringify(body)

    fetchOptions = { method, mode, redirect, credentials, headers, body }

    try return fetch(loginURL, fetchOptions)
    catch err then log err