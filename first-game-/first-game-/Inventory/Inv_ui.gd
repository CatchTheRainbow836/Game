extends Control
@export var is_open: bool = false
@onready var player = get_tree().get_current_scene().get_node("CharacterBody2D")
@onready var inv: Inv = player.inv
@onready var slots := $NinePatchRect/GridContainer.get_children()
var placeholder_tex = preload("res://Inventory/inventory-slot.png")
func _ready():
	visible = false
	is_open = false
	inv.update.connect(Callable(self, "_on_inventory_changed"))
	_on_inventory_changed(inv.slots)

	for btn in slots:
		btn.connect("dragged",Callable(self, "_on_slot_dragged"))
		btn.connect("dropped",Callable(self, "_on_slot_dropped"))

		btn.custom_minimum_size = placeholder_tex.get_size()
		btn.size_flags_horizontal = Control.SIZE_FILL
		btn.size_flags_vertical = Control.SIZE_FILL
		
		
		

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("i"):
		if is_open:
			_close()
		else:
			_open()

func _open():
	visible = true
	is_open = true

func _close():
	visible = false
	is_open = false

func _on_inventory_changed(slots_array: Array[InvSlot]) -> void:
	for i in range(slots.size()):
		var btn: SlotButton = slots[i] as SlotButton
		var slot = slots_array[i]



		
		if slot.item:
			btn.texture_normal = slot.item.texture
			btn.tooltip_text = "Name: %s\nHP: %d\nAtk: %d\nDef: %d\nSpd: %d" % [
				slot.item.name,
				slot.item.health,
				slot.item.attack,
				slot.item.defense,
				slot.item.speed
			]
			btn.item = slot.item
		else:
			btn.texture_normal = placeholder_tex
			print("using placeholder_tex")
			btn.tooltip_text   = ""
			btn.item = null
			
func _on_slot_dragged(from_idx: int, btn: SlotButton) -> void:
	btn.modulate = Color(1,1,1,1)

func _on_slot_dropped(from_idx: int, to_idx: int, item: InvItem) -> void:
	inv.swap_slots(from_idx,to_idx)
