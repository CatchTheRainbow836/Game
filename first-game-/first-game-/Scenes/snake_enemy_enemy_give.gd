extends BaseEnemy
class_name Snake
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(350, 500)
	ui.attack  = randi_range(80, 110)
	ui.defense = randi_range(40, 60)
	ui.speed   = randi_range(70, 100)
	ui.type    = [14, 13] # Poison / Normal
	ui.moves = MovesFactory.get_moves("snake")
