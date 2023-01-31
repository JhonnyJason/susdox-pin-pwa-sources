indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.arrowLeft = document.getElementById("arrow-left")
    global.arrowRight = document.getElementById("arrow-right")
    global.susdoxLogo = document.getElementById("susdox-logo")
    global.addCodeButton = document.getElementById("add-code-button")
    global.loginButton = document.getElementById("login-button")
    global.codeButton = document.getElementById("code-button")
    global.susdoxLogo = document.getElementById("susdox-logo")
    return
    
module.exports = indexdomconnect