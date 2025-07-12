extends BaseEnemy
class_name Yeti
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(1200, 1500)
	ui.attack  = randi_range(130, 170)
	ui.defense = randi_range(120, 160)
	ui.speed   = randi_range(20, 40)
	ui.type    = [12, 17] # Ice / Steel
	ui.moves = MovesFactory.get_moves("yeti")
