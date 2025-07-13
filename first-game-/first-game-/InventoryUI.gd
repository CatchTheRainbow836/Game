extends CanvasLayer

@onready var tab_container: TabContainer = $MainPanel/TabContainer
@onready var pokemon_grid: GridContainer = $MainPanel/TabContainer/InventoryTab/PokemonGrid
@onready var pokemon_details: VBoxContainer = $MainPanel/TabContainer/InventoryTab/PokemonDetails
@onready var pokemon_sprite: TextureRect = $MainPanel/TabContainer/InventoryTab/PokemonDetails/PokemonSprite
@onready var pokemon_name: Label = $MainPanel/TabContainer/InventoryTab/PokemonDetails/PokemonName
@onready var pokemon_stats: RichTextLabel = $MainPanel/TabContainer/InventoryTab/PokemonDetails/PokemonStats
@export var player_path: NodePath

@onready var lore_container = $MainPanel/TabContainer/CollectiblesTab/CollectiblesList/CollectiblesContainer
@onready var lore_text = $MainPanel/TabContainer/CollectiblesTab/CollectibleDetails/CollectibleDescription
@onready var lore_texture = $MainPanel/TabContainer/CollectiblesTab/CollectibleDetails/CollectibleSprite




var is_open: bool = false
var player: CharacterBody2D
var inv: Inv
var hovered_item: InvItem = null

func _ready():
	print("inventory ui script is running")
	player = get_node(player_path)
	if player:
		inv = player.inv
	else:
		push_error("Player node not found at path")
		return
	visible = false
	is_open = false
	
	#$MainPanel/CloseButton.pressed.connect(_close)
	#if inv.update.connect(_on_inventory_changed):
	#	inv.update.disconnect(_on_inventory_changed)
	inv.update.connect(Callable(self,"_on_inventory_changed"))
	
	tab_container.tab_changed.connect(_on_tab_changed)
	_initialize_slots()
	print("Inventory UI ready. Player: ", player, " Inv: ", inv)
	
func _initialize_slots():
	pokemon_grid.add_theme_constant_override("h_separation", 30)
	pokemon_grid.add_theme_constant_override("v_separation", 30)
	
	for btn in pokemon_grid.get_children():
		if btn is SlotButton:
			btn.mouse_entered.connect(_on_slot_hover.bind(btn))
			btn.mouse_exited.connect(_on_slot_unhover)
			
			btn.dragged.connect(_on_slot_dragged)
			btn.dropped.connect(_on_slot_dropped)
			
			btn.custom_minimum_size = Vector2(64,64)
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		else: print("not slot button,intialize_slots")
	
	_on_inventory_changed(inv.slots)

func _on_inventory_changed(slots_array:Array[InvSlot]):
	print("Inventory changed! Slots: ", slots_array)
	
	var buttons = pokemon_grid.get_children()
	
	for i in range(min(slots_array.size(),buttons.size())):
		var btn: SlotButton = buttons[i]
		var slot = slots_array[i]
		
		if slot and slot.item:
			print("Slot ", i, " has item: ", slot.item.name)
			
			btn.texture_normal = slot.item.texture
			btn.item = slot.item
			btn.slot_index = i
		else:
			print("Slot ", 1, "is empty")
			btn.texture_normal = preload("res://Inventory/inventory-slot.png")
			btn.item = null
	if hovered_item:
		_update_pokemon_details(hovered_item)

func _on_slot_hover(btn: SlotButton):
	if btn.item:
		hovered_item = btn.item
		_update_pokemon_details(btn.item)

func _on_slot_unhover():
	hovered_item = null
	#_clear_pokemon_details()

func _update_pokemon_details(item: InvItem):
	if !item:
		print("!item update pokemon details")
		return
	
	pokemon_sprite.texture = item.texture
	pokemon_name.text = item.name
	
	pokemon_stats.text = """
		[b]Type:[/b] {type}
		[b]HP:[/b] {hp}
		[b]Attack:[/b] {atk}
		[b]Defense:[/b] {def}
		[b]Speed[/b] {spd}
	""".format({
		"type": ", ".join(item.type.map(func(t): return _get_type_name(t))),
		"hp": item.health,
		"atk":item.attack,
		"def": item.defense,
		"spd": item.speed
	})

func _get_type_name(type_id: int) -> String:
	match type_id:
		1: return "Bug"
		2: return "Dark"
		3: return "Dragon"
		4: return "Electric"
		5: return "Fairy"
		6: return "Fighting"
		7: return "Fire"
		8: return "Flying"
		9: return "Ghost"
		11: return "Ground"
		12: return "Ice"
		13: return "Normal"
		14: return "Poison"
		15: return "Psychic"
		16: return "Rock"
		17: return "Steel"
		18: return "Water"
		_: return str(type_id)

func _on_tab_changed(tab_index: int):
	match tab_index:
		0:
			print("Switched to Pokemon tab")
			_on_inventory_changed(inv.slots)
		1:
			print("Switched to Collectibles tab")
			_update_collectibles_tab()
	
func _open():
	visible = true
	is_open = true
	get_tree().paused = true
	if pokemon_grid.get_child_count() > 0:
		pokemon_grid.get_child(0).grab_focus()

func _close():
	visible = false
	is_open = false
	get_tree().paused = false
	hovered_item = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("i"):
		if is_open:
			_close()
		else:
			_open()
		get_viewport().set_input_as_handled()

func _on_slot_dragged(from_idx: int, btn: SlotButton):
	btn.modulate = Color(1,1,1,1)

func _on_slot_dropped(from_idx: int, to_idx: int, item: InvItem):
	inv.swap_slots(from_idx,to_idx)
	
func _update_collectibles_tab():
	for child in lore_container.get_children():
		child.queue_free()
	
	for lore in BattleManager.collected_lore:
		var btn = Button.new()
		btn.text = lore.title
		btn.pressed.connect(_on_lore_selected.bind(lore))
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lore_container.add_child(btn)
	if BattleManager.collected_lore.size() > 0:
		_on_lore_selected(BattleManager.collected_lore[0])

func _on_lore_selected(lore:LoreItem):
	lore_text.text = lore.lore_text
	lore_texture.texture = lore.texture
		
