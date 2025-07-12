extends BaseEnemy
class_name Dragon

func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(1000, 1300)
	ui.attack  = randi_range(160, 200)
	ui.defense = randi_range(100, 140)
	ui.speed   = randi_range(70, 100)
	ui.type    = [3, 4]   # Dragon / Electric
	ui.moves = MovesFactory.get_moves("dragon")
