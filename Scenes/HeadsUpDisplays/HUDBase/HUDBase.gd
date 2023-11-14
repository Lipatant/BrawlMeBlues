extends HUD
class_name HUDBase

# OTHER VARIABLES #

var children_hud : Array[HUD]

# RECEIVE DATA #

func _receive_data(data) -> void:
	for child in children_hud:
		if child:
			child.send_data(data)

# REGISTER CHILDREN #

func _on_child_entered_tree(node: Node) -> void:
	if node is HUD and !children_hud.has(node):
		children_hud.append(node)

func _on_child_exiting_tree(node: Node) -> void:
	if node is HUD:
		children_hud.erase(node)
