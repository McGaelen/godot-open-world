class_name Door
extends Node3D

@export var room_A: Room
@export var room_B: Room

@onready var animation_A: AnimationPlayer = $door_A/AnimationPlayer
@onready var animation_B: AnimationPlayer = $door_B/AnimationPlayer

func _ready():
	self.update_visibility()
	if room_A:
		room_A.visibility_changed.connect(self.update_visibility)
	if room_B:
		room_B.visibility_changed.connect(self.update_visibility)


func update_visibility():
	if (room_A and room_A.visible) or (room_B and room_B.visible):
		self.show()
	else:
		self.hide()


func _on_door_entered(body):
	if body.name == 'player':
		room_A.show()
		room_B.show()
		animation_A.play('door_open')
		animation_B.play('door_open')


func _on_door_exited(body):
	animation_A.play_backwards('door_open')
	animation_B.play_backwards('door_open')
	
	Utils.wait_for_signals([
		animation_A.animation_finished,
		animation_B.animation_finished
	], func(_arg): 
		if room_A.room_collider.overlaps_body(body):
			room_A.show()
			room_B.hide()
		elif room_B.room_collider.overlaps_body(body):
			room_B.show()
			room_A.hide()
	)
