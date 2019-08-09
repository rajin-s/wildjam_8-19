extends Node
class_name Component

const component_file_format := "c_%s.gd"

onready var object: Node = $".."

func get_component_on( node: Node, name: String, do_warnings: bool = true ) -> Node:
	name = component_file_format % name
	for i in node.get_child_count():
		var child: Node    = node.get_child( i )
		var script: Script = child.get_script() 
		
		if script != null and script.resource_path.get_file() == name:
			return node

	if do_warnings:
		debug.log( "component", "Failed to find component '%s' on node '%s'" % [ name, node.name ] )
	
	return null

func get_component( name: String ) -> Node:
	return get_component_on( object, name )
