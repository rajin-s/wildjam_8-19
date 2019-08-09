extends Node
# autoload: debug

var _channels := {}

func enable( channel: String ) -> void:
    _channels[channel] = true

func disable( channel: String ) -> void:
    _channels[channel] = false

func log( channel: String, message: String ) -> void:
    if channel in _channels and _channels[channel]:
        print( "[%s] %s" % [ channel, message ] )

func _ready() -> void:
    enable( 'main' )
    enable( 'component' )
