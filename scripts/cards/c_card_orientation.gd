extends Component

export var angle_scale := 10.0
export var angle_speed := 3.0
export var offset      := Vector2( 0,0 )

export var angle_min := Vector2( -30, -30 )
export var angle_max := Vector2( 30, 30 )

var target_angles := Vector2.ZERO
var active        := false

func _ready() -> void:
	pass

func _process( delta: float ) -> void:
	if active:
		update_angles()
	object.rotation_degrees.x = lerp( object.rotation_degrees.x, target_angles.x, delta * angle_speed )
	object.rotation_degrees.y = lerp( object.rotation_degrees.y, target_angles.y, delta * angle_speed )

func enable_orientation() -> void:
	active = true

func disable_orientation() -> void:
	active        = false
	target_angles = Vector2.ZERO

func update_angles() -> void:
	var screen_position: Vector2 = get_viewport().get_camera().unproject_position( object.global_transform.origin )
	var mouse_position: Vector2  = get_viewport().get_mouse_position()
	
	var delta := mouse_position - ( screen_position + offset )
	
	target_angles   = Vector2( delta.y, delta.x ) * angle_scale
	target_angles.x = clamp( target_angles.x, angle_min.x, angle_max.x )
	target_angles.y = clamp( target_angles.y, angle_min.y, angle_max.y )