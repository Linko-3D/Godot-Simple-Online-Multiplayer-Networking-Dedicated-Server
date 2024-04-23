extends Node3D

@export var impact : PackedScene

var has_authority = false

var weapon_sway_amount = 5
var mouse_relative_x = 0.0
var mouse_relative_y = 0.0

func _input(event):
	if not has_authority: return

#	Getting the mouse movement for the weapon sway in the physics process
	if event is InputEventMouseMotion:
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not has_authority: return

	#%Sway.rotation_degrees.z = lerp(%Sway.rotation_degrees.z, -mouse_relative_x / 10.0, weapon_sway_amount * delta)
	#%Sway.rotation_degrees.y = lerp(%Sway.rotation_degrees.y, -mouse_relative_x / 20.0, weapon_sway_amount * delta)
	#%Sway.rotation_degrees.x = lerp(%Sway.rotation_degrees.x, -mouse_relative_y / 10.0, weapon_sway_amount * delta)

	print(mouse_relative_x)
	%Sway.position.x = lerp(%Sway.position.x, -mouse_relative_x / 15000.0, 20 * delta)
	%Sway.position.y = lerp(%Sway.position.y, mouse_relative_y / 20000.0, 20 * delta)


	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.get_joy_axis(0, 7) >= 0.5:
		if %FireRateTimer.is_stopped():
			shoot.rpc(randf_range(0.95, 1.05))
			%FireRateTimer.start()

	if Input.is_key_pressed(KEY_R) or Input.is_joy_button_pressed(0, JOY_BUTTON_Y):
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(%Reload, "rotation_degrees:x", 0, 0)
		tween.tween_property(%Reload, "rotation_degrees:x", 360, 1)
		#$ReloadTween.interpolate_property(weapon, "rotation_degrees:x", 0, 360, 1, Tween.TRANS_BACK, Tween.EASE_IN_OUT, 0)
@rpc("call_local")
func shoot(pitch):
	$RifleShootAudio.play()
	$RifleShootAudio.pitch_scale = pitch
	
	if not %RayCast3D.is_colliding(): return
	var a = impact.instantiate()
	get_tree().get_root().add_child(a)
	a.position = %RayCast3D.get_collision_point()
	#%MapInstance.add_child(map.instantiate())
	
	#var impact_instance = impact.instance()
	#get_tree().get_root().add_child(impact_instance)