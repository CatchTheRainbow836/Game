class_name SlotButton
extends TextureButton

@export var slot_index: int = 0
@export var item: InvItem = null
signal dragged(from_idx: int, btn: SlotButton)
signal dropped(from_idx: int, to_idx: int, item: InvItem)

func _ready():
	focus_mode = FocusMode.FOCUS_ALL
	tooltip_text = ""
	print("Slot", self.name, "Mouse filter:", mouse_filter, "Global Rect:", get_global_rect())


func _get_drag_data(local_pos: Vector2) -> Variant:
	if item == null:
		print("DEBUG: Slot", slot_index, "has no item to drag")
		return null
	var data = {"from": slot_index, "item": item}
	var preview = TextureRect.new()
	preview.texture = item.texture
	preview.size = item.texture.get_size()
	
	
	var half_size = preview.size * 0.5
	var offset    = -local_pos + half_size
	set_drag_preview(preview)
	
	emit_signal("dragged", slot_index, self)
	return data

func _can_drop_data(local_pos: Vector2, data: Variant) -> bool:
	return data.has("item") and data["from"] != slot_index

func _drop_data(local_pos: Vector2, data: Variant) -> void:
	emit_signal("dropped", data.get("from", -1), slot_index, data["item"])
	print("Slot", name, "received drop of item:", data["item"].name)
