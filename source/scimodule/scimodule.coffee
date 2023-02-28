############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("scimodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import { NetworkError } from "./errormodule.js"
import { tokenEndpointURL, imagesEndpointURL } from "./configmodule.js"

############################################################
postData = (url, data) ->
    method = "POST"
    mode = 'cors'
    # redirect =  'follow'
    # credentials = 'include'
    
    # json body
    # headers = { 'Content-Type': 'application/json' }
    # body = JSON.stringify(data)

    # urlencoded body
    headers = { "Content-Type": "application/x-www-form-urlencoded" }
    formData = new URLSearchParams()
    formData.append(lbl, d) for lbl,d of data
    body = formData.toString()


    # options = { method, mode, redirect, credentials, headers, body }
    options = { method, mode, headers, body }

    try 
        # await utl.waitMS(1200)
        response = await fetch(url, options)
        if !response.ok then throw new Error("Response not ok - status: #{response.status}! body: #{await response.text()}")
        return await response.json()
    catch err then throw new NetworkError(err.message)

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
        # await utl.waitMS(1200)
        response = await fetch(url, options)
        if !response.ok then throw new Error("Response not ok - status: #{response.status}! body: #{await response.text()}")
        return await response.json()
    catch err then throw new NetworkError(err.message)

############################################################
export getCredentials = (token) ->
    log "getCredentials"
    return getData(tokenEndpointURL, { token })
  
    # try await postData(tokenEndpointURL, { token })
    # catch err then log err

    # uuid = "bf8603c5-7435-44d4-b1d0-22a5f67441c8"
    # code = "23456789a"
    # dateOfBirth = "2001-02-01"
    # return { uuid, code, dateOfBirth }

############################################################
export getUUID = (dateOfBirth, code) ->
    log "getUUID"
    return getData(tokenEndpointURL, { dateOfBirth, code })
    
    # try await postData(tokenEndpointURL, { dateOfBirth, code })
    # catch err then log err

    # uuid = "bf8603c5-7435-44d4-b1d0-22a5f67441c8"
    # return { uuid, code, dateOfBirth }

############################################################
export getImages = (uuid) ->
    log "getImages"
    return getData(imagesEndpointURL, { uuid })
    
    # try await postData(imagesEndpointURL, { uuid })
    # catch err then log err

    # return [
    #     "/img/umschaden-logo.png"
    #     "/img/karner-logo.jpg"
    # ]

