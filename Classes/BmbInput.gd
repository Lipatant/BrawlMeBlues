class_name BmbInput

static func get_input(input: String, is_using_controller: bool, controller_id: int = 0) -> String:
	if is_using_controller:
		return input + "_" + str(controller_id)
	else:
		return input
