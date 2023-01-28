indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.addCodeButton = document.getElementById("add-code-button")
    global.loginButton = document.getElementById("login-button")
    return
    
module.exports = indexdomconnect