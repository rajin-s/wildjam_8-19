extends Component
tool

export( String, MULTILINE ) var title := "Title" setget set_title
export( String, MULTILINE ) var text  := "Text" setget set_text

func set_title( value: String ) -> void:
    title = value
    
    if Engine.editor_hint:
        # In the editor, this might be called before the whole tree is built, so the node doesn't exist
        if not has_node("../Content/Text Viewport/Text"): return
        
        var label: Label = $"../Content/Title Viewport/Text"
        if label != null:
            label.text = value
        
func set_text( value: String ) -> void:
    text = value
    
    if Engine.editor_hint:
        # In the editor, this might be called before the whole tree is built, so the node doesn't exist      
        if not has_node("../Content/Text Viewport/Text"): return
                
        var label: Label = $"../Content/Text Viewport/Text"
        if label != null:
            label.text = value

func _ready() -> void:
    if not Engine.editor_hint:
        $"../Content/Text Viewport/Text".text = text
        $"../Content/Title Viewport/Text".text = title
