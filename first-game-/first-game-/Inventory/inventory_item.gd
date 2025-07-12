extends Resource

class_name InvItem

#creates the resource for inventory items
@export var name: String = ""
@export var texture: Texture2D
@export var health: int
@export var attack: int
@export var defense: int
@export var speed: int
@export var type: Array[int]
@export var moves: Array = []
@export var max_health: int
