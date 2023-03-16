############################################################
export class NetworkError extends Error
    constructor: (message) ->
        super(message)
        @name = "NetworkError"

############################################################
export class InputError extends Error
    constructor: (message) ->
        super(message)
        @name = "InputError"

############################################################
export class InvalidUserError extends Error
    constructor: (message) ->
        super(message)
        @name = "InvalidUserError"

############################################################
export class ValidationError extends Error
    constructor: (message) ->
        super(message)
        @name = "ValidationError"


############################################################
export class InvalidTokenError extends Error
    constructor: (message) ->
        super(message)
        @name = "InvalidTokenError"

############################################################
export class ExpiredTokenError extends Error
    constructor: (message) ->
        super(message)
        @name = "ExpiredTokenError"

