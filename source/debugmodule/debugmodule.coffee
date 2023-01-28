import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = 
    appcoremodule: true
    # configmodule: true
    # statemodule: true
    # errorfeedbackmodule: true
    # utilmodule: true

addModulesToDebug(modulesToDebug)