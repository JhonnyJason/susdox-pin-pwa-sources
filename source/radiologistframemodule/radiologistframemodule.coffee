############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("radiologistframemodule")
#endregion

############################################################
radiologistframeContainer = document.getElementById("radiologistframe-container")

############################################################
position = 0 # is position one

############################################################
positionToClass = []
positionToClass[0] = "position-one"
positionToClass[1] = "position-two"
positionToClass[2] = "position-three"

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

############################################################
getCurrentClass = -> positionToClass[position]

############################################################
getNextPosition = (direction) ->
    len = positionToClass.length
    pos = ((position + direction) + len ) % len
    return pos

############################################################
getNextClass = (direction) ->
    pos = getNextPosition(direction)
    return positionToClass[pos]

shift = (direction) ->
    currentClass = getCurrentClass()
    nextClass = getNextClass(direction)
    radiologistframeContainer.classList.remove(currentClass)
    radiologistframeContainer.classList.add(nextClass)
    position = getNextPosition(direction)
    return

############################################################
export shiftLeft = ->
    direction = -1
    shift(direction)
    return

############################################################
export shiftRight = ->
    direction = 1
    shift(direction)
    return
