extends BaseEnemy
class_name Lizzard

func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(300, 450)
	ui.attack  = randi_range(60, 90)
	ui.defense = randi_range(30, 50)
	ui.speed   = randi_range(60, 90)
	ui.type    = [7, 12]  # Fire / Ice
	ui.moves = MovesFactory.get_moves("lizzard")
