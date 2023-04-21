class_name Door
extends Node3D

@export var room_A: Room
@export var room_B: Room

@onready var animation_A: AnimationPlayer = $door_A/model/AnimationPlayer
@onready var animation_B: AnimationPlayer = $door_B/model/AnimationPlayer

func _ready():
	self.update_visibility()
	if room_A:
		room_A.visibility_changed.connect(self.update_visibility)
	if room_B:
		room_B.visibility_changed.connect(self.update_visibility)


func open():
	animation_A.play('door_open')
	animation_B.play('door_open')


func close(callback: Callable):
#	animation_A.animation_started.connect(func(_a): print('start'), CONNECT_ONE_SHOT)
	animation_A.play_backwards('door_open')
	animation_B.play_backwards('door_open')
	
	Utils.wait_for_signals([
		animation_A.animation_finished,
		animation_B.animation_finished
	], func(_arg): print('done'))
	
	
#	var num_finished = 0
#	var finished = func(): 
#		num_finished += 1
#		if num_finished == 2:
#			callback.call()
#
#	animation_A.animation_finished.connect(finished, CONNECT_ONE_SHOT)
#	animation_B.animation_finished.connect(finished, CONNECT_ONE_SHOT)


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
	self.close(func(): 
		print('exitedA')
		var player_left_room_A = $door_B/trigger.overlaps_body(body)
		if player_left_room_A:
			room_A.hide()
		else:
			room_B.hide()
	)


func on_door_B_entered(body):
	if body.name == 'player' and not $door_A/trigger.overlaps_body(body):
		room_A.show()
		self.open()


func on_door_B_exited(body):
	self.close(func():
		print('exitedB')
		var player_left_room_B = $door_A/trigger.overlaps_body(body)
		if player_left_room_B:
			room_B.hide()
		else:
			room_A.hide()
	)
