class_name Door
extends Node3D

@export var room_A: Room
@export var room_B: Room

func _ready():
	self.update_visibility()
	if room_A:
		room_A.visibility_changed.connect(self.update_visibility)
	if room_B:
		room_B.visibility_changed.connect(self.update_visibility)

func open():
	$door_A/model/AnimationPlayer.play('door_open')
	$door_B/model/AnimationPlayer.play('door_open')
	
func close():
	$door_A/model/AnimationPlayer.play_backwards('door_open')
	$door_B/model/AnimationPlayer.play_backwards('door_open')

func update_visibility():
	if (room_A and room_A.visible) or (room_B and room_B.visible):
		self.show()
	else:
		self.hide()


func on_door_A_entered(body):
	if body.name == 'player' and not $door_B/trigger.overlaps_body(body):
		room_B.show()
		self.open()


func on_door_A_exited(body):
	self.close()
	var player_left_room_A = $door_B/trigger.overlaps_body(body)
	if player_left_room_A:
		room_A.hide()
	else:
		room_B.hide()


func on_door_B_entered(body):
	if body.name == 'player' and not $door_A/trigger.overlaps_body(body):
		room_A.show()
		self.open()


func on_door_B_exited(body):
	self.close()
	var player_left_room_B = $door_A/trigger.overlaps_body(body)
	if player_left_room_B:
		room_B.hide()
	else:
		room_A.hide()
