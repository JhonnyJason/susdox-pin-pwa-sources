############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("accountmodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import * as utl from "./utilmodule.js"
import * as sci from "./scimodule.js"
import { AuthenticationError } from "./errormodule.js"

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
    
    olog accountObj

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
    log "accountIsValid"
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

        log "LoginRequest was successful!"
        log response
        log "throwing Fake auth Error!"
        throw new AuthenticationError("Fake auth Error!")

        accountValidity[index] = true
    catch err
        log "Error on accountIsValid: #{err.message}"
        # only on auth error, we know it is invalid
        # for any non-auth error we act as if it was valid
        if err instanceof AuthenticationError 
            accountValidity[index] = false
            return false

    return true

export deleteAccount = (index) ->
    log "deleteAccount"
    if noAccount then throw new Error("No User Account Available!")
    if !index? then index = activeAccount
    if index >= allAccounts.length then throw new Error("No account by index: #{index}")

    deleteCurrentAccount = index == activeAccount
    activeAccountWasZero = activeAccount == 0

    allAccounts.splice(index, 1)
    accountValidity.splice(index, 1)

    if allAccounts.length == 0 
        noAccount = true
        activeAccount = NaN
        s.save("activeAccount", NaN)
        S.save("allAccounts")
        return

    if deleteCurrentAccount and activeAccountWasZero
        S.save("allAccounts")
        S.callOnChangeListeners("activeAccount")

    if deleteCurrentAccount and !activeAccountWasZero
        S.save("allAccounts")
        activeAccount--
        s.save("activeAccount", activeAccount)

    if !deleteCurrentAccount and index < activeAccount
        activeAccount--
        s.saveSilently("activeAccount", activeAccount)

    return

############################################################
export updateImages = (index) ->
    log "updateImages"
    if noAccount then throw new Error("No User Account Available!")
    if !index? then index = activeAccount
    if index >= allAccounts.length then throw new Error("No account by index: #{index}")

    accountObj = allAccounts[index]

    try
        oldImages = accountObj.radiologistImages
        credentials = accountObj.userCredentials
        allImages = new Set(oldImages)

        newImages = await sci.getImages(credentials)
        
        allImages.add(image) for image in newImages
        accountObj.radiologistImages = [...allImages]
    catch err then log "Error on updateImages: #{err.message}"
    return

