tool
extends Spatial

export (Array, NodePath) var exclude_paths
export (String) var collector_group

var children: Array = []
var excludes: Array = []

func _ready():
	children = get_children()
	for path in exclude_paths:
		excludes.append(get_node(path))
	
func _get_configuration_warning():
	for child in get_children():
		if !"influence" in child:
			return "All children must to be of type BrightnessProbe"
	return ""
	
func collect() -> float:
	var check: float
	var count = 0
	var light_level: float = 0.0
	for light in get_tree().get_nodes_in_group(collector_group):
		for child in children:
			light_level += child.influence * light.get_light_level(excludes, child.global_transform.origin)
			count += child.influence
	if count == 0:
		return light_level
	return light_level / count
