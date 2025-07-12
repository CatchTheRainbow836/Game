extends Resource

class_name Inv

signal update(slots_array)

@export var slots: Array[InvSlot]

#Puts items into the inventory, if one slot is full, the next one will be taken
func insert(item: InvItem):
	var itemslots = slots.filter(func(slot):return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	emit_signal("update", slots)
	
func swap_slots(from: int, to: int):
	var tmp = slots[from]
	slots[from] = slots[to]
	slots[to] = tmp
	emit_signal("update", slots)
