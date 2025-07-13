extends Node2D

@export var lore_item: LoreItem
var player_in_range: bool = false

func _ready() -> void:
	var img = Image.create(16,16,false,Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	
	for x in 16:
		for y in 16:
			var dist = Vector2(x-8,y-8).length()
			if dist <= 8:
				img.set_pixel(x,y,Color.WHITE)
	var tex = ImageTexture.create_from_image(img)
	$Sprite2D.texture = tex
	
	$InteractionPrompt.visible = false

func _on_detection_area_body_entered(body):
	if body is Player:
		player_in_range = true
		$InteractionPrompt.visible = true

func _on_detection_area_body_exited(body):
	if body is Player:
		player_in_range = false
		$InteractionPrompt.visible = false

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		collect()

func collect():
	if lore_item.unlock_condition != "" and !BattleManager.check_condition(lore_item.unlock_condition):
		print("cannot obtain item yet")
		return
	BattleManager.collect_lore(lore_item)
	queue_free()
