extends BaseEnemy
class_name Frog
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(350, 500)
	ui.attack  = randi_range(50, 80)
	ui.defense = randi_range(40, 60)
	ui.speed   = randi_range(70, 100)
	ui.type    = [18, 13] # Water / Normal
	ui.moves = MovesFactory.get_moves("frog")
