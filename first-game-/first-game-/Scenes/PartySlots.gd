extends HBoxContainer
@export var max_slots := 3
@onready var inv: Inv = Inventory.inv
@export_node_path var party_slots_path: NodePath

@export_node_path var confirm_button_path: NodePath
@onready var confirm_button: Button = get_node(confirm_button_path)
@onready var slots_container: Control = get_node(party_slots_path)

var selected_items: Array[InvItem] = []

func can_drop_data(position, data) -> bool:
	var valid = data.has("item") and selected_items.size() < max_slots
	print("[can_drop_data] Valid drop? ", valid)
	return valid

func drop_data(position, data) -> void:
	if data.has("item"):
		var item = data ["item"]
		selected_items.append(item)
		print("[drop_data] Dropped item: ", item.name)
		print("[drop_data] selected_items now: ", selected_items)
		_refresh_slots()
	else:
		print("[drop_data] Error: No 'item' in drop data!")
	

func _refresh_slots() -> void:
	print("[_refresh_slots] Refreshing slots... selected_items: ", selected_items)
	confirm_button.disabled = selected_items.any(func(i): return i == null) or selected_items.size() != max_slots
	var buttons = slots_container.get_children()
	for i in range(buttons.size()):
		var btn = buttons[i] as SlotButton
		var item = selected_items[i] if i < selected_items.size() else null
		
		if item != null:
			btn.texture_normal = item.texture
			btn.tooltip_text = item.name
			btn.item = item
			print("[_refresh_slots] Slot", i, "set to", item.name)
		else:
			btn.texture_normal = preload("res://Inventory/inventory-slot.png")
			btn.tooltip_text = ""
			btn.item = null
			print("[_refresh_slots] Slot", i, "cleared to placeholder")

func _ready() -> void:
	var buttons = slots_container.get_children()
	selected_items.resize(buttons.size())
	print("[_ready] Connecting slot drag forwarding...")
	for i in range(buttons.size()):
		var btn = buttons[i] as SlotButton
		if btn is SlotButton:
			btn.slot_index = i
			btn.connect("dragged", Callable(self, "_on_slot_dragged"))
			btn.connect("dropped", Callable(self, "_on_slot_dropped"))
			btn.set_drag_forwarding(
				Callable(btn, "_get_drag_data"),
				Callable(btn, "_can_drop_data"),
				Callable(btn, "_drop_data")
			)

	_refresh_slots()
func _on_slot_dragged(from_idx: int, btn: SlotButton) -> void:
	print("[_on_slot_dragged] From index:", from_idx)
func _on_slot_dropped(from_idx: int, to_idx: int, item: InvItem) -> void:
	print("[_on_slot_dropped] From", from_idx, "→ To", to_idx, "item:", item.name)
	selected_items[to_idx] = item
	if from_idx >= 0 and from_idx < selected_items.size() and from_idx != to_idx:
		selected_items[from_idx] = null
	_refresh_slots()
func _get_drag_data(at_position: Vector2) -> Variant:
	return null
	
