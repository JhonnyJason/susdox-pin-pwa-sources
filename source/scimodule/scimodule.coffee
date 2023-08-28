############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("scimodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import { NetworkError, AuthenticationError } from "./errormodule.js"
import { tokenEndpointURL, imagesEndpointURL } from "./configmodule.js"
import { loginURL } from "./configmodule.js"

############################################################
postData = (url, data) ->
    method = "POST"
    mode = 'cors'
    # redirect =  'follow'
    credentials = 'include'
    
    # json body
    headers = { 'Content-Type': 'application/json' }
    body = JSON.stringify(data)

    # urlencoded body
    # headers = { "Content-Type": "application/x-www-form-urlencoded" }
    # formData = new URLSearchParams()
    # formData.append(lbl, d) for lbl,d of data
    # body = formData.toString()

    # options = { method, mode, redirect, credentials, headers, body }
    options = { method, mode, credentials, headers, body }

    try 
        response = await fetch(url, options)
        if response.ok then return await response.json()
        
        error = new Error("#{await response.text()}")
        error.status = response.status
        throw error

    catch err
        if err.status == 401 then throw new AuthenticationError(err.message)
        throw new NetworkError(err.message)
    return

############################################################
getData = (url, data) ->
    method = "GET"
    mode = 'cors'

    # urlencoded body
    formData = new URLSearchParams()
    formData.append(lbl, d) for lbl,d of data
    url += "/?"+formData.toString()

    options = { method, mode }


    try
        response = await fetch(url, options)
        if response.ok then return await response.text()
        
        error = new Error("#{await response.text()}")
        error.status = response.status
        throw error
    catch err
        if err.status == 401 then throw new AuthenticationError(err.message)
        throw new NetworkError(err.message)
        # baseMsg = "Error! GET API request could not receive a JSON response!"
        
        # try 
        #     bodyText = "Body:  #{await response.text()}"
        #     statusText = "HTTP-Status: #{response.status}"
        # catch err2
        #     details = "No response could be retrieved! details: #{err.message}"
        #     errorMsg = "#{baseMsg} #{details}" 
        #     throw new NetworkError(errorMsg)

        # details = "#{statusText} #{bodyText}"
        # errorMsg = "#{baseMsg} #{details}"
        # throw new NetworkError(errorMsg)
    return

############################################################
export getImages = (credentials) ->
    ## prod log "getImages"
    return postData(imagesEndpointURL, credentials)
    # return getData(imagesEndpointURL, credentials)
    
    # try await postData(imagesEndpointURL, { uuid })
    # catch err then log err

    # return [
    #     "/img/umschaden-logo.png"
    #     "/img/karner-logo.jpg"
    # ]

############################################################
export loginWithRedirect = (body) ->
    ## prod log "loginWithRedirect"
    method = "POST"
    mode = 'cors'
    redirect =  'follow'
    credentials = 'include'
    
    headers = { 'Content-Type': 'application/json' }
    body = JSON.stringify(body)

    fetchOptions = { method, mode, redirect, credentials, headers, body }

    try 
        response = await fetch(loginURL, fetchOptions)
        if response.ok then return await response.text()
        
        error = new Error("#{await response.text()}")
        error.status = response.status
        throw error
    catch err
        if err.status == 401 then throw new AuthenticationError(err.message)
        throw new NetworkError(err.message)
    return

############################################################
export loginRequest = (body) ->
    method = "POST"
    mode = 'cors'
    redirect =  'manual'
    credentials = 'include'
    # credentials = 'omit'
    
    # json body
    headers = { 'Content-Type': 'application/json' }
    body = JSON.stringify(body)

    fetchOptions = { method, mode, redirect, credentials, headers, body }

    try 
        response = await fetch(loginURL, fetchOptions)
        if response.ok then return await response.text()
        
        error = new Error("#{await response.text()}")
        error.status = response.status
        throw error
    catch err
        if err.status == 401 then throw new AuthenticationError(err.message)
        throw new NetworkError(err.message)
    return

############################################################
#region deprecated Code
# ############################################################
# export getCredentials = (token, dateOfBirth) ->
#     ## prod log "getCredentials"
#     response = await getData(tokenEndpointURL, { token, dateOfBirth })
#     if response.error?
#         msg = "Error in response on getCredentials - token: '#{token}' | dateOfBirth: '#{dateOfBirth}'"
#         if response.error == "tokenInvalid" then  throw new InvalidTokenError(msg)
#         if response.error == "tokenExpired" then  throw new ExpiredTokenError(msg)
#         if response.error == "validationFailed" then  throw new ValidationError(msg)
#         throw new NetworkError("Unexpected Error! error: '#{response.error}' | #{msg}")
#     return response

#     # try await postData(tokenEndpointURL, { token })
#     # catch err then log err

#     # uuid = "bf8603c5-7435-44d4-b1d0-22a5f67441c8"
#     # code = "23456789a"
#     # dateOfBirth = "2001-02-01"
#     # return { uuid, code, dateOfBirth }

# ############################################################
# export getUUID = (dateOfBirth, code) ->
#     ## prod log "getUUID"
#     response = await getData(tokenEndpointURL, { dateOfBirth, code })
#     if response.error? then throw new InvalidUserError()
#     return response.uuid
    
#     # try await postData(tokenEndpointURL, { dateOfBirth, code })
#     # catch err then log err

#     # uuid = "bf8603c5-7435-44d4-b1d0-22a5f67441c8"
#     # return { uuid, code, dateOfBirth }
#endregion
