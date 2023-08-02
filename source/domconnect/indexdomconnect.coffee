indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.susdoxLogo = document.getElementById("susdox-logo")
    global.menuCloseButton = document.getElementById("menu-close-button")
    global.menuButton = document.getElementById("menu-button")
    global.invalidcodemodal = document.getElementById("invalidcodemodal")
    global.logoutmodal = document.getElementById("logoutmodal")
    global.codeverificationmodal = document.getElementById("codeverificationmodal")
    global.codeverificationBirthdayInput = document.getElementById("codeverification-birthday-input")
    return
    
module.exports = indexdomconnect