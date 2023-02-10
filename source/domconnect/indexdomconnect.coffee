indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.susdoxLogo = document.getElementById("susdox-logo")
    global.menuCloseButton = document.getElementById("menu-close-button")
    global.menuButton = document.getElementById("menu-button")
    global.usermodal = document.getElementById("usermodal")
    global.useractionFrame = document.getElementById("useraction-frame")
    global.useractionCloseButton = document.getElementById("useraction-close-button")
    global.useractionAcceptButton = document.getElementById("useraction-accept-button")
    global.useractionRejectButton = document.getElementById("useraction-reject-button")
    return
    
module.exports = indexdomconnect