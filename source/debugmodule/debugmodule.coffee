import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = 
    
    appcoremodule: true
    # configmodule: true
    datamodule: true
    menumodule: true
    # statemodule: true
    # errorfeedbackmodule: true
    credentialsframemodule: true
    usermodalmodule: true
    # utilmodule: true

addModulesToDebug(modulesToDebug)