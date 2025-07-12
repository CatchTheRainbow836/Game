extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display

#defines slot
#states that if the slot does not have an item, then it is not visible
func update(slot: InvSlot):
	item_visual.visible = slot.item != null
	if slot.item:
		item_visual.texture = slot.item.texture
