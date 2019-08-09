extends Node

onready var art : Spatial = $"Separator/Object/Art"

signal mouse_entered
signal mose_exited

signal drag_started
signal drag_ended

func _ready() -> void:
    var area: Area = $"Separator/Object/Area"