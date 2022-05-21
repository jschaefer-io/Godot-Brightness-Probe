tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("BrightnessCollector", "Spatial", preload("brightness_collector.gd"), preload("icon.svg"))
	add_custom_type("BrightnessResolver", "Spatial", preload("brightness_resolver.gd"), preload("icon.svg"))
	add_custom_type("BrightnessProbe", "Spatial", preload("brightness_probe.gd"), preload("icon.svg"))

func _exit_tree():
	remove_custom_type("BrightnessCollector")
	remove_custom_type("BrightnessResolver")
	remove_custom_type("BrightnessProbe")
