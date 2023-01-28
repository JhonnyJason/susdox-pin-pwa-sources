indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.susdoxLogo = document.getElementById("susdox-logo")
    global.addCodeButton = document.getElementById("add-code-button")
    global.loginButton = document.getElementById("login-button")
    global.susdoxLogo = document.getElementById("susdox-logo")
    return
    
module.exports = indexdomconnect