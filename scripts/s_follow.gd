extends Spatial

export var target_path      := @".."
onready var target: Spatial  = get_node( target_path )

export var speed := 4.0

func _process( delta: float ) -> void:
    var position        := global_transform.origin
    var target_position := target.global_transform.origin
    
    position = position.linear_interpolate( target_position, delta * speed )

    global_transform.origin = position

    scale = scale.linear_interpolate( target.scale, delta * speed )
    