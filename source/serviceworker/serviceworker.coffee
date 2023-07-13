import { appVersion } from "./configmodule.js"

############################################################
log = (arg) -> console.log("[serviceworker] #{arg}")

############################################################
# appCacheName = "PIN-PWA#{appVersion}"
appCacheName = "PIN-PWAmain"
imageCacheName = "PIN-PWAimages"
fontCacheName = "PIN-PWAfonts"

############################################################
appFiles = [
    "/",
    "/manifest.json"
    "/android-chrome-96x96.png"
    "/apple-touch-icon.png"
    "/browserconfig.xml"
    "/favicon.ico"
    "/favicon-32x32.png"
    "/favicon-16x16.png"
    "/mstile-150x150.png"
    "/safari-pinned-tab.svg"
]

############################################################
fontEndings = /.(o|t)tf$|.woff2?$/ # for otf,ttf,woff and woff2
imageEndings = /.png$|.jpg$|.jpeg$|.webp$|.gif$/

############################################################
urlMatchOptions = {
    ignoreSearch: true
}

############################################################
onRegister = ->
    log "onRegister"
    self.addEventListener('activate', activateEventHandler)
    self.addEventListener('fetch', fetchEventHandler)
    self.addEventListener('install', installEventHandler)
    self.addEventListener('message', messageEventHandler)

    clients = await self.clients.matchAll({ includeUncontrolled: true })
    message = "postRegister"
    client.postMessage(message) for client in clients  

    log "postRegister: found #{clients.length} clients!"
    return

############################################################
#region Event Handlers
activateEventHandler = (evnt) ->
    log "activateEventHandler"
    evnt.waitUntil(self.clients.claim())
    log "clients have been claimed!"
    return

 
fetchEventHandler = (evnt) -> 
    # log "fetchEventHandler"
    # log evnt.request.url
    evnt.respondWith(cacheThenNetwork(evnt.request))
    return

installEventHandler = (evnt) -> 
    log "installEventHandler"
    self.skipWaiting()
    log "skipped waiting :-)"
    evnt.waitUntil(installAppCache())
    return

messageEventHandler = (evnt) ->
    log "messageEventHandler"
    log "typeof data is #{typeof evnt.data}"
    log JSON.stringify(evnt.data, null, 4)
    log "I am version #{appVersion}!"

    # Commands to be executed
    if evnt.data == "tellMeVersion"
        # get all available Windoes and tell them the new Version is here :-)
        clients = await self.clients.matchAll({includeUncontrolled: true})
        message = {version: appVersion}
        client.postMessage(message) for client in clients
    
    if evnt.data == "deleteImageCache" then await caches.delete(imageCacheName)

    return

#endregion

############################################################
#region helper functions
installAppCache = ->
    log "installAppCache"
    try
        # await caches.delete(fontCacheName) # probably unnecessary and probably we can do this more sophisticatedly
        cache = await caches.open(appCacheName)
        return cache.addAll(appFiles)
    catch err then log "Error on installAppCache: #{err.message}"
    return

cacheThenNetwork = (request) ->
    log "cacheThenNetwork"
    try cacheResponse = await caches.match(request, urlMatchOptions)
    catch err then log err
    if cacheResponse? then return cacheResponse
    else return handleCacheMiss(request)
    return


############################################################
handleCacheMiss = (request) ->
    # log "handleCacheMiss"
    if fontEndings.test(request.url) then return handleFontMiss(request)
    if imageEndings.test(request.url) then return handleImageMiss(request)
    return fetch(request)
    
handleImageMiss = (request) ->
    # log "handleImageMiss"
    # log request.url
    try
        cache = await caches.open(imageCacheName)
        return cache.add(request)
    catch err then log "Error on handleImageMiss: #{err.message}"
    return fetch(request)

handleFontMiss = (request) ->
    # log "handleFontMiss"
    # log request.url
    try
        cache = await caches.open(fontCacheName)
        return cache.add(request)
    catch err then log "Error on fontImageMiss: #{err.message}"
    return fetch(request)

#endregion


############################################################
onRegister()
