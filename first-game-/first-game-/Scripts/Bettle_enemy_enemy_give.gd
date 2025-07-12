extends BaseEnemy
class_name Bettle
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(400, 600)
	ui.attack  = randi_range(70, 100)
	ui.defense = randi_range(80, 110)
	ui.speed   = randi_range(40, 70)
	ui.type    = [1, 8]   # Bug / Flying
	ui.moves = MovesFactory.get_moves("bettle_enemy")

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

	
