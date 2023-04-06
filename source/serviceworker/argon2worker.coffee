import libsodium from "libsodium-wrappers-sumo"
import { bytesToHex } from "thingy-byte-utils"

sodium = null

initialize = ->
    await libsodium.ready
    sodium = libsodium

calculateArgon2 = (pin,birthdate) ->
    salt = birthdate + "SUSDOX"

    hash = sodium.crypto_pwhash(
        32,        # Output size in bytes
        pin,       # Will be converted to a UTF-8 Uint8Array by sodium.js
        salt,      # Dito
        1,         # Number of hash iterations
        67108864,  # Use 64MB memory
        sodium.crypto_pwhash_ALG_ARGON2ID13	# Hash algorithm: argon2id
    )
    hashHex = bytesToHex(hash)
    return hashHex


onmessage = (evnt) ->
    { pin, birthdate } = evnt.data
    if !pin? or !birthdate? then postMessage({error:"Invalid Arguments!"})
    try 
        if !sodium? then await initialize()
        hashHex = calculateArgon2(pin, birthdate)
        postMessage({hashHex})
    catch error then postMessage(error)
    return
