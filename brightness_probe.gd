tool
extends Spatial

export (int) var influence = 1

func _ready():
	set_process(false)
	set_physics_process(false)
