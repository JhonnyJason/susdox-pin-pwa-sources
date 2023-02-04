indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.menuFrame = document.getElementById("menu-frame")
    global.arrowLeft = document.getElementById("arrow-left")
    global.arrowRight = document.getElementById("arrow-right")
    global.susdoxLogo = document.getElementById("susdox-logo")
    global.addCodeButton = document.getElementById("add-code-button")
    global.acceptButton = document.getElementById("accept-button")
    global.codeButton = document.getElementById("code-button")
    global.menuMoreInfo = document.getElementById("menu-more-info")
    global.menuLogout = document.getElementById("menu-logout")
    global.menuVersion = document.getElementById("menu-version")
    global.susdoxLogo = document.getElementById("susdox-logo")
    global.menuCloseButton = document.getElementById("menu-close-button")
    global.menuButton = document.getElementById("menu-button")
    return
    
module.exports = indexdomconnect