class_name Room
extends Node3D

@onready var room_collider: Area3D = $room_collider:
	set(val):
		room_collider = val
		update_configuration_warnings()

func _init():
	super()

#func _ready():
#	pass

func _get_configuration_warnings():
	if room_collider == null:
		return ["Room needs to have a child Area3D node named `room_collider` in order to know when the player is inside this Room."]
	else:
		return []
