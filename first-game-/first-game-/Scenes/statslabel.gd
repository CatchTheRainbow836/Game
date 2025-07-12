extends Label

# go two levels up: Label → AnimatedSprite2D → Node2D (your BaseEnemy)
@onready var enemy_root := get_parent()

func _process(delta: float) -> void:
	var inv_item = enemy_root.get("item")
	if inv_item == null:
		text = "-- no item set --"
		return

	text = "Name: %s\nHealth: %d\nAttack: %d\nDefense: %d\nSpeed: %d\nType IDs: %s" % [
		inv_item.name,
		inv_item.health,
		inv_item.attack,
		inv_item.defense,
		inv_item.speed,
		inv_item.type,
	]
