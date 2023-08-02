import Modules from "./allmodules"
import domconnect from "./indexdomconnect"
domconnect.initialize()

global.allModules = Modules

############################################################
if navigator? and navigator.serviceWorker? then navigator.serviceWorker.register("serviceworker.js")

############################################################
appStartup = -> Modules.appcoremodule.startUp()

############################################################
run = ->
    promises = (m.initialize() for n,m of Modules when m.initialize?) 
    await Promise.all(promises)
    appStartup()

############################################################
run()