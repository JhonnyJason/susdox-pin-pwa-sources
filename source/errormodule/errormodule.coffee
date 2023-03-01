############################################################
export class NetworkError extends Error
    constructor: (details) ->
        message = "Network Error: #{details}"
        super(message)
        @name = "NetworkError"


############################################################
export class InputError extends Error
    constructor: (details) ->
        message = "Input Error: #{details}"
        super(message)
        @name = "InputError"

############################################################
export class InvalidUserError extends Error
    constructor: (details) ->
        message = "Invalid User Error: #{details}"
        super(message)
        @name = "InvalidUserError"
