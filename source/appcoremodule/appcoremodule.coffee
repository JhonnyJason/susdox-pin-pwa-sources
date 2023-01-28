############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import * as content from "./contentmodule.js"

############################################################
loggedIn = false
credentialsPickUp = false

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

############################################################
#region internal Functions

############################################################
checkCookies = ->
    log "checkCookies"
    allCookies = document.cookie
    log "allCookies where: "+allCookies

    cookies = allCookies.split(";")
    
    passwordExists = false
    usernameExists = false
    
    for cookie in cookies
        c = cookie.trim()
        if c.indexOf("password=") == 0 
            passwordExists = true
            S.save("passwordCookie", c)

        if c.indexOf("username=") == 0
            usernameExists = true
            S.save("usernameCookie", c)

    if passwordExists and usernameExists 
        loggedIn = true
        return

    passwordCookie = S.load("passwordCookie")
    usernameCookie = S.load("usernameCookie")
    ## TODO 
    log "We did not find both username and password in the cookies..."
    log "Reconstructing cookies from our store would contain:"
    olog {
        passwordCookie,
        usernameCookie
    }
    return

############################################################
checkURLParams = ->
    log "checkURLParams"
    paramString = window.location.search
    if !paramString then return
    log "We had some URL Params:"
    olog {paramString}
    return

############################################################
pickUpCredentials = ->
    log "pickUpCredentials"
    ## TODO
    return

#endregion

############################################################
export startUp = ->
    log "startUp"

    ## Check if we are already logged..
    checkCookies()
    if loggedIn
        log "We are logged in already ;-)"
        content.setToUserPage()
        return

    log "We were not logged in!"

    ## Check if we got some parameters to login automatically
    checkURLParams()
    if credentialsPickUp
        credentials = await pickUpCredentials()
        log "We could pick up some credentials ;-)"
        olog {credentials}
        try await autoLogin(credentials)
        catch err 
            log "error: we could not autoLogin! \n"+err.message
            return
        content.setToUserPage()        
        return

    return



