############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("accountmodule")
#endregion

############################################################
import * as S from "./statemodule.js"

############################################################
activeAccount = NaN
allAccounts = []
accountValidity = []

noAccount = true

############################################################
export initialize = ->
    log "initialize"
    allAccounts = S.load("allAccounts") || []
    S.save("allAccounts", allAccounts, true)
    activeAccount = parseInt(S.load("activeAccount"))
    olog { allAccounts, activeAccount }
    return unless allAccounts.length > 0

    noAccount = false
    return

############################################################
export getUserCredentials = (index) ->
    log "getUserCredentials"
    if noAccount then throw new Error("No User Account Available!")
    if !index? then index = activeAccount
    if index >= allAccounts.length then throw new Error("No account by index: #{index}")

    accountObj = allAccounts[index]
    return accountObj.userCredentials

export getRadiologistImages = (index) ->
    log "getRadiologistImages"
    if noAccount then throw new Error("No User Account Available!")
    if !index? then index = activeAccount
    if index >= allAccounts.length then throw new Error("No account by index: #{index}")

    accountObj = allAccounts[index]
    return accountObj.radiologistImages

############################################################
export addNewAccount = (credentials) ->
    log "addNewAccount"
    accountIndex = allAccounts.length
    accountObj = {}
    accountObj.userCredentials = credentials
    accountObj.radiologistImages = []
    accountObj.label = "Benutzer 1"
    allAccounts.push(accountObj)
    S.save("allAccounts")
    noAccount = false
    return accountIndex

export setAccountActive = (index) ->
    log "setAccountActive"
    if noAccount then throw new Error("No User Account Available!")
    if !index? then index = activeAccount
    if index >= allAccounts.length then throw new Error("No account by index: #{index}")

    activeAccount = index
    S.save("activeAccount", index)
    return

export setAccountValid = (index) ->
    log "setAccountValid"
    if noAccount then throw new Error("No User Account Available!")
    if !index? then index = activeAccount
    if index >= allAccounts.length then throw new Error("No account by index: #{index}")

    accountValidity[index] = true
    return

export accountIsValid = (index) ->
    log "setAccountValid"
    if noAccount then throw new Error("No User Account Available!")
    if !index? then index = activeAccount
    if index >= allAccounts.length then throw new Error("No account by index: #{index}")

    if typeof accountValidity[index] == "boolean" 
        return accountValidity[index]
    
    # account is valid when loginRequest succeeds
    try
        credentials = allAccounts[index].userCredentials
        loginBody = utl.loginRequestBody(credentials)
        response = await sci.loginRequest(loginBody)
        log response
        accountValidity[index] = true
    catch err
        log err
        if err instanceof AuthenticationError 
            accountValidity[index] = false
            return false

    return true

