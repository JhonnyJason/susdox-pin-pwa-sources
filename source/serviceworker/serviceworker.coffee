import { appVersion } from "./configmodule.js"

############################################################
appCacheName = appVersion
imageCacheName = "images"
fontCacheName = "font"

############################################################
appFiles = [
    "/",
    "/manifest.json"
]

############################################################
fontEndings = ""

############################################################
self.addEventListener('install', installEventHandler) 
self.addEventListener('fetch', fetchEventHandler)

############################################################
#region Event Handlers
fetchEventHandler = (event) ->
    # if event.request.
    event.respondWith(cacheAnswer(event.request))
    return

installEventHandler = (event) -> 
    event.waitUntil(cacheInstall())
    return

#endregion

############################################################
#region helper functions

# returns a Promise as it is an asnc function as we await on other stuff ;-)
cacheAnswer = (request) ->
    try return await caches.match(request)
    catch err then return fetch(request)


# returns a Promise as it is an asnc function as we await on other stuff ;-)
cacheInstall = ->
    try await caches.delete(cacheName)
    catch err # make clean install and remain silent when something goes wrong
    cache = await caches.open(cacheName)
    await cache.addAll filesToCache
    return

#endregion    
