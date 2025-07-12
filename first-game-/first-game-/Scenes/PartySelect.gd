extends Control
const PartySelectScene = preload("res://Scenes/fixed_party_select.tscn")
@export var BattleScene: PackedScene
@onready var confirm_btn: Button = $CenterContainer/Panel/ConfirmButton

func _ready():
	confirm_btn.connect("pressed", Callable(self, "_on_confirm_pressed"))
	print("PartySelect READY - pos:", position, " size:", size)
	self.visible = true
	self.set_anchors_preset(Control.PRESET_FULL_RECT)
	self.z_index = 100
	$CenterContainer/Panel/ConfirmButton.disabled = true
	for btn in $CenterContainer/Panel/PartySlots.get_children():
		btn.connect("dropped", Callable(self, "_on_slot_dropped"))

	
	
func _on_confirm_pressed():
	BattleManager.party =$CenterContainer/Panel/PartySlots.selected_items.duplicate()

	var battle_ui = BattleScene.instantiate() as Control
	battle_ui.name = "BattleUI"
	battle_ui.set_anchors_preset(Control.PRESET_FULL_RECT)
	get_parent().add_child(battle_ui)
	queue_free()

func _gui_input(event):
	if event is InputEventMouse:
		print("UI blocking input at: ", event.position)
