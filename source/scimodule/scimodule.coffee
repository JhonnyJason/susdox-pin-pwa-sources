############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("scimodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import { NetworkError, AuthenticationError } from "./errormodule.js"

import { 
    tokenEndpointURL, dataEndpointURL, 
    screeningsEndpointURL, loginURL 
    } from "./configmodule.js"

############################################################
postData = (url, data) ->
    method = "POST"
    mode = 'cors'
    credentials = 'include'
    
    ## this most probably is not needed but to make the request exactly the same as  the login request...
    redirect = 'manual'

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
        throw new NetworkError("#{err.message}. Code: #{err.status}")
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
        throw new NetworkError("#{err.message}. Code: #{err.status}")
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
export getRadiologistsData = (credentials) ->
    log "getRadiologistsData"
    return postData(dataEndpointURL, credentials)
    # return getData(dataEndpointURL, credentials)
    
    # try await postData(dataEndpointURL, { uuid })
    # catch err then log err

    # return [
    #     "/img/umschaden-logo.png"
    #     "/img/karner-logo.jpg"
    # ]

export getScreenings = (credentials) ->
    log "getScreenings"
    return postData(screeningsEndpointURL, credentials)

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

    olog fetchOptions
    try 
        response = await fetch(loginURL, fetchOptions)
        # if response.ok then return await response.text()
        ## TODO: use json from response
        if response.ok then return await response.json()
        
        error = new Error("#{await response.text()}")
        error.status = response.status
        throw error
    catch err
        if err.status == 401 then throw new AuthenticationError(err.message)
        throw new NetworkError("#{err.message}. Code: #{err.status}")
    return

############################################################
#region deprecated Code

############################################################
export loginWithRedirect = (body) ->
    log "loginWithRedirect"
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
        throw new NetworkError("#{err.message}. Code: #{err.status}")
    return



# ############################################################
# export getCredentials = (token, dateOfBirth) ->
#     log "getCredentials"
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
#     log "getUUID"
#     response = await getData(tokenEndpointURL, { dateOfBirth, code })
#     if response.error? then throw new InvalidUserError()
#     return response.uuid
    
#     # try await postData(tokenEndpointURL, { dateOfBirth, code })
#     # catch err then log err

#     # uuid = "bf8603c5-7435-44d4-b1d0-22a5f67441c8"
#     # return { uuid, code, dateOfBirth }
#endregion
