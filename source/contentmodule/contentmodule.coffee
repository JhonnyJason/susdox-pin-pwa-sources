############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import * as credentialsframe from "./credentialsframemodule.js"
import * as radiologistFrame from "./radiologistframemodule.js"
import * as codeDisplay from "./codedisplaymodule.js"
import * as menuModule from "./menumodule.js"

############################################################
export initialize = ->
    log "initialize"
    addCodeButton.addEventListener("click", addCodeButtonClicked)
    acceptButton.addEventListener("click", acceptButtonClicked)

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
    content.classList.add("setting-credentials")
    return

############################################################
acceptButtonClicked = (evnt) ->
    log "acceptButtonClicked"
    try 
        credentialsframe.extractCredentials()
        setToUserPage()
        
        # await utl.waitMS(5000)
        # credentialsframe.resetAllErrorFeedback()
       
        # loginBody = await extractCodeFormBody()
        # olog {loginBody}

        # if !loginBody.hashedPw and !loginBody.username then return

        # response = await doLoginRequest(loginBody)
        
        # if !response.ok then errorFeedback("codePatient", ""+response.status)
        # else location.href = loginRedirectURL

    catch err then return credentialsframe.errorFeedback("codePatient", "Other: " + err.message)
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
    content.classList.remove("preload")
    content.classList.remove("setting-credentials")
    content.classList.remove("credentials-set")
    
    menuModule.setMenuOff()

    ## TODO remove rest
    # content.classList.remove("")
    
    return

############################################################
export setToUserPage = ->
    log "setToUserPage"
    content.classList.remove("preload")
    content.classList.remove("setting-credentials")
    content.classList.add("credentials-set")
    
    ## actually unnecessary here but for completeness sake ;-)
    menuModule.setMenuOff()

    ## TODO adjust rest
    # content.classList.remove("")
    # content.classList.add("")
    
    return