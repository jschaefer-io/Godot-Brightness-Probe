tool
extends Spatial

var light: Light
var dss: PhysicsDirectSpaceState

func _ready():
	light = get_parent()
	dss = light.get_world().direct_space_state

func _get_configuration_warning():
	if !get_parent() is Light:
		return "Must be a direct child of a Node of type Light"
	return ""
	
func _is_line_of_sight(from: Vector3, to: Vector3, excludes: Array, raycast_layers: int) -> bool:
	return dss.intersect_ray(to, from, excludes, raycast_layers, true, false).empty()
	
func _get_omni_light_level(target: Vector3, excludes: Array, raycast_layers: int) -> float:
	var check_light: OmniLight = light
	var distance = (check_light.global_transform.origin - target).length()
	if distance > check_light.omni_range:
		return 0.0
	if !_is_line_of_sight(check_light.global_transform.origin, target, excludes, raycast_layers):
		return 0.0
	return pow(1 - distance / check_light.omni_range, check_light.omni_attenuation)
	
func _get_spot_light_level(target: Vector3, excludes: Array, raycast_layers: int) -> float:
	var check_light: SpotLight = light
	var path = light.global_transform.origin - target
	var distance = (check_light.global_transform.origin - target).length()
	if distance > check_light.spot_range:
		return 0.0
	var angle = light.global_transform.basis.z.angle_to(path)
	var check_angle = deg2rad(check_light.spot_angle)
	if  angle > check_angle:
		return 0.0
	if !_is_line_of_sight(check_light.global_transform.origin, target, excludes, raycast_layers):
		return 0.0
	var res = min(
		pow(1 - distance / check_light.spot_range, check_light.spot_attenuation),
		pow(1 - angle / check_angle, 1 / check_light.spot_angle_attenuation)
	)
	return res
	
func _get_directional_light_level(target: Vector3, excludes: Array, raycast_layers: int) -> float:
	if !_is_line_of_sight(target, light.global_transform.basis.z * 100000, excludes, raycast_layers):
		return 0.0
	var check_light: DirectionalLight = light
	return min(check_light.light_energy, 1)
	
func get_light_level(target: Vector3, excludes: Array, raycast_layers: int) -> float:
	if light is OmniLight:
		return _get_omni_light_level(target, excludes, raycast_layers)
	if light is SpotLight:
		return _get_spot_light_level(target, excludes, raycast_layers)
	if light is DirectionalLight:
		return _get_directional_light_level(target, excludes, raycast_layers)
	return 0.0
