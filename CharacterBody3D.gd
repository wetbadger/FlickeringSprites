extends CharacterBody3D


const SPEED = 1
const JUMP_VELOCITY = 4.5

func _ready():
	$NavigationAgent3D.target_position = position

func _input(_event):
	if Input.is_action_just_pressed("click"):
		set_move_position(get_viewport().get_mouse_position())
		
func set_move_position(mouse_pos):
		var camera = get_tree().get_current_scene().get_node("Camera3D")
		var rayLength = 500
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * rayLength
		var space = get_world_3d().direct_space_state
		var rayQuery = PhysicsRayQueryParameters3D.new()
		rayQuery.from = from
		rayQuery.to = to
		rayQuery.collide_with_areas = false
		var result = space.intersect_ray(rayQuery)
		if result and not result.collider is CharacterBody3D:
			$NavigationAgent3D.target_position = result.position

func move_to_point(_delta):
	var targetPos = $NavigationAgent3D.target_position
	var direction = global_position.direction_to(targetPos)
	velocity = direction * SPEED
	move_and_slide()

func _process(delta):
	move_to_point(delta)
