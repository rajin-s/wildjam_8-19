extends ViewportContainer

onready var viewport: Viewport = $"Viewport"

func _ready() -> void:
	update_size()
	get_viewport().connect( "size_changed", self, "update_size" )

func update_size() -> void:
	viewport.size = get_viewport().size

func _unhandled_input( event: InputEvent ) -> void:
	viewport.unhandled_input( event )
