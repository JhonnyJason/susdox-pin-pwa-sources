############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("pwainstallmodule")
#endregion

############################################################
import * as menu from "./menumodule.js"

############################################################
deferredInstallPrompt = null

############################################################
# environment = NaN
env = {
    os: "other", browser: "other", inApp: false
}

############################################################
howToToShow = null
appIsInstalled = false

############################################################
# ### Firefox Android HowTo
# - userAgent includes "firefox" and "android"
# ### Firefox Desktop HowTo
# - userAgent include "firefox" but not "android" (Probably it does not matter if Linux, MacOS or Windows)
# ### iOS HowTo
# - Either "ipad", "iphone" or "ipod" in userAgent, or "macintosh" in userAgent with maxTouchPoints > 1
# - On iOS other Apps cannot have "add to Homescreen functionality" ... maybe later
# ### MacOS HowTo
# - "macintosh" in userAgent and maxTouchPoints  = 0

############################################################
export initialize = ->
    log "initialize"
    pwainstallHowtoBackground.addEventListener("click", howtoBackgroundClicked)
    window.addEventListener("beforeinstallprompt", onBeforeInstallPrompt)
    window.addEventListener("appinstalled", onAppInstalled)

    window.matchMedia('(display-mode: standalone)').addEventListener("change",onDisplayModeChange)
    
    checkAppInstallation()
    checkIfInstalled()
    checkEnvironment()
    decideOnHowTo()

    setTimeout(showButtonManually, 5000)

    olog {env, howToToShow}
    
    showDebugInfo()
    return

############################################################
showDebugInfo = ->
    str1 = JSON.stringify(env, null, 4)
    str2 = "howToToShow: #{howToToShow}"
    str3 = window.navigator.userAgent.toLowerCase()
    html = """
    <p>#{str1}</p>
    <p>#{str2}</p>
    <p>#{str3}</p>
    """
    document.getElementById("pwainstall-debug").innerHTML = html
    return 


############################################################
onBeforeInstallPrompt = (e) ->
    log "beforeInstallPrompt"
    e.preventDefault()

    howToToShow = null
    deferredInstallPrompt = e

    menu.setInstallableOn()    
    return

onAppInstalled = (e) ->
    log "onAppInstalled"
    menu.setInstallableOff()
    deferredInstallPrompt = null    
    return

howtoBackgroundClicked = (evnt) ->
    log "howtoBackgroundClicked"
    log howToToShow
    if howToToShow == "ios" 
        pwainstallHowtoBackground.classList.remove("howto-ios")
        return

    if howToToShow == "mac" 
        pwainstallHowtoBackground.classList.remove("howto-mac")
        return

    if howToToShow == "firefox-android"
        pwainstallHowtoBackground.classList.remove("howto-firefox-android")
        return

    if howToToShow == "firefox-desktop"
        pwainstallHowtoBackground.classList.remove("howto-firefox-desktop")
        return
    return

############################################################
checkAppInstallation = ->
    log "checkAppInstallation"
    if window.matchMedia('(display-mode: standalone)').matches
        env.inApp = true
    if window.matchMedia('(installed: yes)').matches
        env.inApp = true
    
    if document.referrer.startsWith('android-app://') 
        env.inApp = true

    if navigator.standalone  then env.inApp = true
    return

onDisplayModeChange = (evnt) ->
    log "onDisplayModeChange"
    if evnt.matches then env.inApp = true
    else env.inApp = false
    return

############################################################
checkIfInstalled = ->
    log "checkIfInstalled"
    if env.inApp 
        appIsInstalled = true
        return

    return unless navigator.getInstalledRelatedApps?
    log "navigator.getInstalledRelatedApps exists"
    
    results = await navigator.getInstalledRelatedApps()
    olog results
    log results.length

    if Array.isArray(results) and results.length > 0 
        appIsInstalled = true   
    return

checkEnvironment = ->
    log "checkEnvironment"
    userAgent = window.navigator.userAgent.toLowerCase()
    log userAgent

    containsFirefox = userAgent.indexOf("firefox") > -1 
    containsSafari = userAgent.indexOf("safari") > -1
    containsChrome = userAgent.indexOf("chrome") > -1
    containsCRIOS = userAgent.indexOf("crios") > -1
    containsOPR = userAgent.indexOf("opr") > -1
    containsAndroid = userAgent.indexOf("android") > -1 
    containsMacintosh = userAgent.indexOf("macintosh") > -1
    containsIPhone = userAgent.indexOf("iphone") > -1
    containsIPad = userAgent.indexOf("ipad") > -1
    multiTouch = navigator.maxTouchPoints > 1

    if containsIPhone or containsIPad or (containsMacintosh and multiTouch) then env.os = "ios"
    else if containsMacintosh and !multiTouch then env.os = "mac"
    else if containsAndroid then env.os = "android"
    else env.os = "other"

    if containsFirefox then env.browser = "firefox"
    if containsOPR then env.browser = "opera"
    else if containsChrome and containsSafari then env.browser = "chrome"
    else if containsCRIOS and containsSafari then env.browser = "chrome"
    else if containsSafari then env.browser = "safari"
    else env.browser = "other"

    return

decideOnHowTo = ->
    log "decideOnHowTo"
    if env.os == "android" and env.browser == "firefox"
        howToToShow = "firefox-android"
        return
    
    if env.os == "ios"
        howToToShow = "ios"
        return

    if env.browser == "firefox"
        howToToShow = "firefox-desktop"
        return
    
    if env.os == "mac"
        howToToShow = "mac"
        return

    # TODO remove when we have more HowTos
    if howToToShow != "ios" then howToToShow = null
    return

############################################################
showHowTo = ->
    log "showHowTo"
    log howToToShow
    if howToToShow == "ios" 
        pwainstallHowtoBackground.classList.add("howto-ios")
        return

    if howToToShow == "mac" 
        pwainstallHowtoBackground.classList.add("howto-mac")
        return

    if howToToShow == "firefox-android"
        pwainstallHowtoBackground.classList.add("howto-firefox-android")
        return

    if howToToShow == "firefox-desktop"
        pwainstallHowtoBackground.classList.add("howto-firefox-desktop")
        return

    return

############################################################
showButtonManually = ->
    log "showButtonManually"
    return if appIsInstalled
    return unless howToToShow?
    menu.setInstallableOn()
    return


############################################################
export promptForInstallation = ->
    log "promptForInstallation"
    return if appIsInstalled
    if howToToShow? then return showHowTo()
    return unless deferredInstallPrompt?

    try
        # choice = await deferredInstallPrompt.userChoice()
        choiceObject = await deferredInstallPrompt.prompt()
        olog choiceObject
        if choiceObject.outcome == "accepted"
            log "doing installation..."
            menu.setInstallableOff()
            deferredInstallPrompt = null
        else  
            log "doing nothing..."
    return
