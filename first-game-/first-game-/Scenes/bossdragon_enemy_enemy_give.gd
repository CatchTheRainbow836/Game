extends BaseEnemy
class_name BossDragon
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(1500, 1800)
	ui.attack  = randi_range(200, 250)
	ui.defense = randi_range(150, 200)
	ui.speed   = randi_range(60, 90)
	ui.type    = [3, 17]  # Dragon / Steel
	ui.moves = MovesFactory.get_moves("bossdragon")
