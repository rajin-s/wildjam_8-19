extends Node

onready var art: Spatial = $"Separator/Object/Art"

signal mouse_entered
signal mouse_exited

signal drag_started
signal drag_ended

var drag_active := false

func on_mouse_entered() -> void:
    emit_signal( "mouse_entered" )
    
func on_mouse_exited() -> void:
    emit_signal( "mouse_exited" )

func on_input( camera: Camera, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int ) -> void:
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
        drag_active = true
        emit_signal( "drag_started" )

func _input ( event: InputEvent ) -> void:
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
        if drag_active:
            drag_active = false
            emit_signal( "drag_ended" )

func _ready() -> void:
    var area: Area = $"Separator/Object/Area"
    area.connect( "mouse_entered", self, "on_mouse_entered" )
    area.connect( "mouse_exited", self, "on_mouse_exited" )
    area.connect( "input_event", self, "on_input" )