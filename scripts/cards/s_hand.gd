extends Spatial

export var row_spacing        := 1.0
export var row_offset_base    := 0.1
export var row_offset         := 0.1
export var row_height_offset  := -0.1
export var row_offset_scaling := 0.9

onready var row: Spatial    = $"Row"
onready var active: Spatial = $"Active"

var focus_node: Node  = null
var focus_index      := 0

func _ready() -> void:
    connect_card_signals()

func _process( delta: float ) -> void:
    update_row()

func connect_card_signals() -> void:
    for i in row.get_child_count():
        var child: Node = row.get_child( i )
        var area: Area  = child.get_node( "Separator/Object/Area" )

        if not area.is_connected( "mouse_entered", self, "focus" ):
            area.connect( "mouse_entered", self, "focus", [ child ] )
            area.connect( "mouse_exited", self, "unfocus", [ child ] )

func focus( node: Node ) -> void:
    if node.get_parent() != row: return

    if focus_node != null:
        focus_node.disable_parallax()

    focus_node = node
    focus_node.enable_parallax()
    
    focus_index = node.get_index()

func unfocus( node: Node ) -> void:
    pass

func update_row() -> void:
    for i in row.get_child_count():
        var offset := abs( i - focus_index )
        
        var child: Spatial       = row.get_child( i )
        child.transform.origin.x = i * row_spacing
        child.transform.origin.y = offset * row_height_offset
        child.transform.origin.z = 0 if i == focus_index else ( row_offset_base + row_offset * offset )
        
        child.scale = Vector3.ONE * pow( row_offset_scaling, offset )

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
