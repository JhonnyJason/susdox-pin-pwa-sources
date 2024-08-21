indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.realBody = document.getElementById("real-body")
    global.footer = document.getElementById("footer")
    global.addressDisplay = document.getElementById("address-display")
    global.content = document.getElementById("content")
    global.centerbutton = document.getElementById("centerbutton")
    global.susdoxLogo = document.getElementById("susdox-logo")
    global.menuCloseButton = document.getElementById("menu-close-button")
    global.menuButton = document.getElementById("menu-button")
    global.pwainstallHowtoBackground = document.getElementById("pwainstall-howto-background")
    global.invalidcodemodalContentMessageTemplate = document.getElementById("invalidcodemodal-content-message-template")
    global.invalidcodemodal = document.getElementById("invalidcodemodal")
    global.logoutmodalContentMessageTemplate = document.getElementById("logoutmodal-content-message-template")
    global.logoutmodal = document.getElementById("logoutmodal")
    global.codeverificationmodal = document.getElementById("codeverificationmodal")
    global.codeverificationBirthdayInput = document.getElementById("codeverification-birthday-input")
    return
    
module.exports = indexdomconnect