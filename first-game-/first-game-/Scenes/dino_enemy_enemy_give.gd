extends BaseEnemy
class_name Dino
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(800, 1000)
	ui.attack  = randi_range(100, 140)
	ui.defense = randi_range(60, 90)
	ui.speed   = randi_range(50, 80)
	ui.type    = [3, 13]  # Dragon / Normal
	ui.moves = MovesFactory.get_moves("dino")
