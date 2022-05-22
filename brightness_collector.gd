tool
extends Spatial

export (Array, NodePath) var exclude_paths = []
export (int, LAYERS_3D_RENDER) var raycast_layers = 0x7FFFFFFF
export (String) var collector_group = ""

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
	var collected_level: float = 0.0
	var count: int
	var level: float
	for light in get_tree().get_nodes_in_group(collector_group):
		count = 0.0
		level = 0.0
		for child in children:
			level += child.influence * light.get_light_level(child.global_transform.origin, excludes, raycast_layers)
			count += child.influence
		if count != 0:
			collected_level += level / count
	return min(collected_level, 1)
