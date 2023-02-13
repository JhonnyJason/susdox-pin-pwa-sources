import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = 
    
    appcoremodule: true
    # configmodule: true
    # credentialsframemodule: true
    cubemodule: true
    datamodule: true
    # errorfeedbackmodule: true
    # menumodule: true
    radiologistimagemodule: true
    # statemodule: true
    # usermodalmodule: true
    # utilmodule: true

addModulesToDebug(modulesToDebug)