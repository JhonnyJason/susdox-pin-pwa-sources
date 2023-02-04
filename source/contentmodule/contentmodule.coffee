############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import * as loginFrame from "./loginframemodule.js"
import * as radiologistFrame from "./radiologistframemodule.js"
import * as codeDisplay from "./codedisplaymodule.js"
import * as menuModule from "./menumodule.js"

############################################################
export initialize = ->
    log "initialize"
    addCodeButton.addEventListener("click", addCodeButtonClicked)
    loginButton.addEventListener("click", loginButtonClicked)

    arrowLeft.addEventListener("click", arrowLeftClicked)
    arrowRight.addEventListener("click", arrowRightClicked)

    codeButton.addEventListener("click", codeButtonClicked)

    menuFrame.addEventListener("click", menuFrameClicked)
    return


############################################################
menuFrameClicked = (evnt) ->
    log "menuFrameClicked"
    menuModule.setMenuOff()
    return

############################################################
addCodeButtonClicked = (evnt) ->
    log "addCodeButtonClicked"
    content.classList.add("login")
    return

############################################################
loginButtonClicked = (evnt) ->
    log "loginButtonClicked"
    content.classList.add("logging-in")
    try
        await utl.waitMS(5000)
        # loginFrame.resetAllErrorFeedback()
       
        # loginBody = await extractCodeFormBody()
        # olog {loginBody}

        # if !loginBody.hashedPw and !loginBody.username then return

        # response = await doLoginRequest(loginBody)
        
        # if !response.ok then errorFeedback("codePatient", ""+response.status)
        # else location.href = loginRedirectURL

        setToUserPage()
    catch err then return loginFrame.errorFeedback("codePatient", "Other: " + err.message)
    finally content.classList.remove("logging-in")
    return

############################################################
arrowLeftClicked = (evnt) ->
    log "arrowLeftClicked"
    codeDisplay.reset()
    radiologistFrame.shiftLeft()
    return    

############################################################
arrowRightClicked = (evnt) ->
    log "arrowRightClicked"
    codeDisplay.reset()
    radiologistFrame.shiftRight()    
    return
    
############################################################
codeButtonClicked = (evnt) ->
    codeDisplay.revealOrCopy()
    return


############################################################
export setToDefault = ->
    log "setToDefault"
    content.classList.remove("login")
    content.classList.remove("logging-in")
    content.classList.remove("logged-in")
    
    menuModule.setMenuOff()

    codeDisplay.reset()
    
    ## TODO remove rest
    # content.classList.remove("")
    
    return

############################################################
export setToUserPage = ->
    log "setToUserPage"
    content.classList.remove("login")
    content.classList.remove("logging-in")
    content.classList.add("logged-in")
    
    ## actually unnecessary here but for completeness sake ;-)
    menuModule.setMenuOff()

    ## TODO
    sampleCode = "234  567 89a"
    codeDisplay.setCode(sampleCode)

    ## TODO adjust rest
    # content.classList.remove("")
    # content.classList.add("")
    
    return