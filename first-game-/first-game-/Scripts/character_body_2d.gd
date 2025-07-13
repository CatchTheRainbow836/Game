extends CharacterBody2D
class_name Player

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var spawnpos1 = Vector2()
@export var spawnpos2 = Vector2()
@onready var animated_sprite = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"."
@export var inv: Inv = preload("res://Inventory/Items/playerinv.tres")







var spawnnumber = randi() % 2 
#Random spawning of character
func _ready() -> void:
	print("Player ready. Position:", global_position)
	BattleManager.player = self
	if spawnnumber == 0:
		player.global_position = spawnpos1
		print("Spawned at spawnpos1:", spawnpos1)
	else:
		player.global_position = spawnpos2
		print("Spawned at spawnpos2:", spawnpos2)

#Adds movement
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


#creates function "collect" to put items into the inventory
func collect(item: InvItem):
	print("PLAYER.collect() got: ", item.name)
	inv.insert(item)
