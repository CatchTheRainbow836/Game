extends BaseEnemy
class_name Ant
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(200, 350)
	ui.attack  = randi_range(30, 60)
	ui.defense = randi_range(10, 25)
	ui.speed   = randi_range(60, 90)
	ui.type    = [1, 13]  # Bug / Normal
	ui.moves = MovesFactory.get_moves("ant_enemy")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
