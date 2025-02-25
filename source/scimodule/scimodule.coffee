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
    screeningsEndpointURL, codeRequestURL, 
    loginURL, logoutURL, desktopLoginURL
    } from "./configmodule.js"

chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
############################################################
randomPad = ->
    result = ''
    length = Math.random() * 512
    cnt = 0
    while (cnt < length)
        result += chars.charAt(Math.floor(Math.random() * chars.length));
        cnt += 1;
    return result;

############################################################
postData = (url, data) ->
    method = "POST"
    mode = 'cors'
    credentials = "include"

    # json body
    headers = { 'Content-Type': 'application/json' }
    body = JSON.stringify(data)

    options = { method, mode, credentials, headers, body }

    # log "postData" 
    olog body ## if we uncomment this then safari looses the body object
    # olog options

    try
        console.log(url)
        response = await fetch(url, options)
        console.log(response.status)

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
    credentials = "include"

    # urlencoded body
    formData = new URLSearchParams()
    formData.append(lbl, d) for lbl,d of data
    url += "/?"+formData.toString()

    options = { method, mode, credentials }


    try
        response = await fetch(url, options)
        if response.ok then return await response.json()
        
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
    # olog credentials
    # credentials.random = randomPad()    
    
    return await postData(dataEndpointURL, credentials)
    # credentials.endpoint = "data"
    # return await postData(loginURL, credentials)

    # return getData(dataEndpointURL, credentials)
    
    # try await postData(dataEndpointURL, { uuid })
    # catch err then log err

    # return [
    #     "/img/umschaden-logo.png"
    #     "/img/karner-logo.jpg"
    # ]

export getScreenings = (credentials) ->
    log "getScreenings"
    # olog credentials
    # credentials.random = randomPad()
    return await postData(screeningsEndpointURL, credentials)
    # credentials.endpoint = "studies"
    # return await postData(loginURL, credentials)

############################################################
export requestCode = (requestObj) ->
    log "requestCode"
    return await postData(codeRequestURL, requestObj)

############################################################
export loginRequest = (body) ->
    method = "POST"
    mode = 'cors'
    credentials = "include"


    headers = { 'Content-Type': 'application/json' }
    body = JSON.stringify(body)
    
    fetchOptions = { method, mode, credentials, headers, body }

    # log "loginRequest"
    # olog body
    # olog fetchOptions

    try 
        console.log(loginURL)
        response = await fetch(loginURL, fetchOptions)
        console.log(response.status)
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

export logoutRequest = ->
    method = "POST"
    mode = 'cors'
    credentials = "include"
    
    fetchOptions = { method, mode, credentials }

    try    
        response = await fetch(logoutURL, fetchOptions)
        console.log(response.status)
    
        if response.ok then return await response.json()
        
        error = new Error("#{await response.text()}")
        error.status = response.status
        throw error
    catch err
        if err.status == 401 then throw new AuthenticationError(err.message)
        throw new NetworkError("#{err.message}. Code: #{err.status}")
    return

############################################################
export desktopLogin = (body) ->
    log "desktopLogin"
    method = "POST"
    mode = 'cors'
    credentials = "include"

    headers = { 'Content-Type': 'application/json' }
    body = JSON.stringify(body)

    # log body
    fetchOptions = { method, mode, credentials, headers, body }
    # olog fetchOptions
    try 
        response = await fetch(desktopLoginURL, fetchOptions)
        if response.ok then return await response.json()
        
        error = new Error("#{await response.text()}")
        error.status = response.status
        throw error
    catch err
        if err.status == 401 then throw new AuthenticationError(err.message)
        throw new NetworkError("#{err.message}. Code: #{err.status}")
    return


############################################################
export desktopLoginWithRedirect = (body) ->
    log "desktopLoginWithRedirect"
    method = "POST"
    mode = 'cors'
    redirect =  'follow'
    credentials = "include"

    headers = { 'Content-Type': 'application/json' }
    body = JSON.stringify(body)

    # log body
    fetchOptions = { method, mode, redirect, credentials, headers, body }
    # olog fetchOptions
    try 
        response = await fetch(desktopLoginURL, fetchOptions)
        if response.ok then return await response.text()
        
        error = new Error("#{await response.text()}")
        error.status = response.status
        throw error
    catch err
        if err.status == 401 then throw new AuthenticationError(err.message)
        throw new NetworkError("#{err.message}. Code: #{err.status}")
    return

