import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = 
    
    appcoremodule: true
    # configmodule: true
    datamodule: true
    # statemodule: true
    # errorfeedbackmodule: true
    credentialsframemodule: true
    # utilmodule: true

addModulesToDebug(modulesToDebug)