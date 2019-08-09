extends Component
tool

export( String, MULTILINE ) var title := "Title" setget set_title
export( String, MULTILINE ) var text  := "Text" setget set_text

func set_title( value: String ) -> void:
    title = value
    
    var label: Label = $"../Separator/Object/Title/Viewport/Text"
    if label != null:
        label.text = title
        
func set_text( value: String ) -> void:
    text = value
            
    var label: Label = $"../Separator/Object/Text/Viewport/Text"
    if label != null:
        label.text = text
