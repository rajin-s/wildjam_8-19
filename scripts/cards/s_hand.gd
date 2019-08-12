extends Spatial

export var row_spacing        := 1.0
export var row_offset_base    := 0.1
export var row_offset         := 0.1
export var row_height_offset  := -0.1
export var row_offset_scaling := 0.9

onready var row: Spatial    = $"Row"
onready var active: Spatial = $"Active"

var held: Spatial = null
var held_depth: float

var focus_node: Node  = null
var focus_index      := 0

export var corner_offset := Vector2(1, 1)

func _ready() -> void:
    connect_card_signals()

func _process( delta: float ) -> void:
    update_row()
    update_held()

func connect_card_signals() -> void:
    for i in row.get_child_count():
        var child: Node = row.get_child( i )

        if not child.is_connected( "mouse_entered", self, "focus" ):
            child.connect( "mouse_entered", self, "focus", [ child ] )
            child.connect( "mouse_exited", self, "unfocus", [ child ] )
            child.connect( "drag_started", self, "start_drag", [ child ] )
            child.connect( "drag_ended", self, "end_drag", [ child ] )

func focus( node: Node ) -> void:
    if node.get_parent() != row: return
    if held != null: return

    focus_node  = node
    focus_index = node.get_index()

func unfocus( node: Node ) -> void:
    pass

func update_row() -> void:
    var camera := get_viewport().get_camera()
    var bottom_left := Vector2(0, get_viewport().size.y)
    var row_pos: Vector3 = camera.project_position(bottom_left, 5)
    row_pos.x = row_pos.x * 100 + corner_offset.x
    row_pos.y = row_pos.y * 100 + corner_offset.y
    row.global_transform.origin = row_pos
    
    for i in row.get_child_count():
        var offset := abs( i - focus_index )
        
        var child: Spatial       = row.get_child( i )
        child.transform.origin.x = i * row_spacing
        child.transform.origin.y = offset * row_height_offset
        child.transform.origin.z = 0 if i == focus_index else ( row_offset_base + row_offset * offset )
        
        child.scale = Vector3.ONE * pow( row_offset_scaling, offset )

func update_held() -> void:
    if held != null:
        var camera := get_viewport().get_camera()

        var current_screen: Vector2 = get_viewport().get_mouse_position()
        var current_world: Vector3  = camera.project_position( current_screen, held_depth )
        current_world.x *= 100
        current_world.y *= 100
        # This seems like a bug? Have to multiply resulting world position by approximately the far clip plane distance...??

        held.global_transform.origin = current_world
        

# DEBUG INPUT
func _input( event ) -> void:
    if event.is_echo(): return
    if not event is InputEventKey or not event.is_pressed(): return

    match event.scancode:
        KEY_A:
            var c = row.get_child( 0 )
            row.remove_child( c )
            row.add_child( c )
        KEY_EQUAL:
            focus_index += 1
        KEY_MINUS:
            focus_index -= 1

func start_drag( node: Node ) -> void:
    debug.log( "card", "Start dragging %s" % node.name )
    if node.get_parent() != row:
        debug.log( "card", "start_drag called for card '%s' not in row" % node.name )
        return
    
    var start_position: Vector3 = node.global_transform.origin
    row.remove_child( node )
    active.add_child( node )
    node.global_transform.origin = start_position

    var camera := get_viewport().get_camera()
    held_depth  = camera.global_transform.basis.z.dot( camera.global_transform.origin - node.global_transform.origin )
    held        = node

    print( "depth=%f" % held_depth )

func end_drag( node: Node ) -> void:
    debug.log( "card", "Finish dragging %s" % node.name )
    if node.get_parent() != active:
        debug.log( "card", "end_drag called for card '%s' not child of active" % node.name )
        return

    if node == held:
        held = null
    else:
        debug.log( "card", "end_drag called for card '%s' that isn't held" % node.name )
    
    var start_position: Vector3 = node.global_transform.origin
    active.remove_child( node )
    row.add_child( node )
    node.global_transform.origin = start_position
