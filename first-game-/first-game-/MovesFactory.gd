extends Node
class_name MovesFactory
static func get_moves(enemy_name: String) -> Array:
	match enemy_name:
		"ant_enemy":
			return [
				{ "name":"Bite",       "power":35,  "type":9,  "accuracy":95 },
				{ "name":"Pinch",      "power":25,  "type":1,  "accuracy":100, "status":"paralysis", "status_chance":20 },
				{ "name":"Stun Spore", "power":0,   "type":1,  "accuracy":75,  "status":"paralysis", "status_chance":100 }
			]
		"bat":
			return [
				{ "name":"Wing Attack", "power":40, "type":8,  "accuracy":100 },
				{ "name":"Bite",        "power":60, "type":9,  "accuracy":100 },
				{ "name":"Confuse Ray", "power":0,  "type":9,  "accuracy":100, "status":"confusion",  "status_chance":100 }
			]
		"bear":
			return [
				{ "name":"Slash",       "power":70, "type":13, "accuracy":100 },
				{ "name":"Bulk Up",     "power":0,  "type":13, "accuracy":100, "status":"attack_buff", "status_chance":100 },
				{ "name":"Roar",        "power":0,  "type":13, "accuracy":100, "status":"intimidate",  "status_chance":100 }
			]
		"bettle_enemy":
			return [
				{ "name":"Tackle",     "power":50,  "type":13, "accuracy":95 },
				{ "name":"Bug Buzz",   "power":75,  "type":1,  "accuracy":90 },
				{ "name":"Poison Sting","power":15, "type":14, "accuracy":100, "status":"poison", "status_chance":20 }
			]
		"dino":
			return [
				{ "name":"Stomp",      "power":65,  "type":13, "accuracy":100 },
				{ "name":"Earthquake", "power":100, "type":11, "accuracy":85 },
				{ "name":"Roar",       "power":0,   "type":13, "accuracy":100, "status":"intimidate", "status_chance":100 }
			]
		"Dog_enemy":
			return [
				{ "name":"Bite",       "power":60,  "type":9,  "accuracy":100 },
				{ "name":"Howl",       "power":0,   "type":13, "accuracy":100, "status":"attack_buff", "status_chance":100 },
				{ "name":"Fire Fang",  "power":65,  "type":7,  "accuracy":95,  "status":"burn", "status_chance":10 }
			]
		"eagle":
			return [
				{ "name":"Drill Peck", "power":80,  "type":8,  "accuracy":100 },
				{ "name":"Gust",       "power":40,  "type":8,  "accuracy":100 },
				{ "name":"Tailwind",   "power":0,   "type":8,  "accuracy":100, "status":"speed_buff", "status_chance":100 }
			]
		"ghost":
			return [
				{ "name":"Shadow Ball","power":80,  "type":9,  "accuracy":100 },
				{ "name":"Hex",        "power":65,  "type":9,  "accuracy":100 },
				{ "name":"Curse",      "power":0,   "type":9,  "accuracy":100, "status":"curse", "status_chance":100 }
			]
		"bird":
			return [
				{ "name":"Peck",       "power":35,  "type":13, "accuracy":100 },
				{ "name":"Air Slash",  "power":75,  "type":8,  "accuracy":95,  "status":"flinch", "status_chance":30 },
				{ "name":"Roost",      "power":0,   "type":8,  "accuracy":100, "status":"heal",    "status_chance":100 }
			]
		"frog":
			return [
				{ "name":"Water Gun",  "power":40,  "type":18, "accuracy":100 },
				{ "name":"Mud Shot",   "power":55,  "type":11, "accuracy":95,  "status":"speed_down", "status_chance":30 },
				{ "name":"Poison Ivy", "power":0,   "type":14, "accuracy":90,  "status":"poison", "status_chance":50 }
			]
		"gator":
			return [
				{ "name":"Crunch",     "power":80,  "type":9,  "accuracy":100 },
				{ "name":"Aqua Tail",  "power":90,  "type":18, "accuracy":90 },
				{ "name":"Ice Fang",   "power":65,  "type":12, "accuracy":95,  "status":"freeze", "status_chance":10 }
			]
		"grasshopper":
			return [
				{ "name":"Quick Attack","power":40, "type":13, "accuracy":100 },
				{ "name":"Leech Life",  "power":80,  "type":1,  "accuracy":90,  "status":"heal", "status_chance":100 },
				{ "name":"Poison Jab",  "power":80,  "type":14, "accuracy":100, "status":"poison", "status_chance":30 }
			]
		"bossdragon":
			return [
				{ "name":"Dragon Claw","power":80,  "type":3,  "accuracy":100 },
				{ "name":"Fire Blast", "power":110, "type":7,  "accuracy":85,  "status":"burn", "status_chance":10 },
				{ "name":"Thunder",    "power":110, "type":4,  "accuracy":70,  "status":"paralysis", "status_chance":30 }
			]
		"lizzard":
			return [
				{ "name":"Flamethrower","power":90,  "type":7,  "accuracy":100, "status":"burn", "status_chance":10 },
				{ "name":"Dragon Breath","power":60, "type":3,  "accuracy":100, "status":"freeze", "status_chance":10 },
				{ "name":"Smokescreen", "power":0,   "type":7,  "accuracy":100, "status":"accuracy_down", "status_chance":100 }
			]
		"snake":
			return [
				{ "name":"Poison Fang","power":50,  "type":14, "accuracy":100, "status":"poison", "status_chance":50 },
				{ "name":"Slither",    "power":40,  "type":13, "accuracy":100 },
				{ "name":"Coil",       "power":0,   "type":14, "accuracy":100, "status":"defense_buff", "status_chance":100 }
			]
		"opossum":
			return [
				{ "name":"Scratch",    "power":40,  "type":13, "accuracy":100 },
				{ "name":"Play Dead",  "power":0,   "type":13, "accuracy":100, "status":"paralysis", "status_chance":100 },
				{ "name":"Bite",       "power":60,  "type":9,  "accuracy":100 }
			]
		"owl":
			return [
				{ "name":"Night Slash","power":70,  "type":9,  "accuracy":100 },
				{ "name":"Air Slash",  "power":75,  "type":8,  "accuracy":95,  "status":"flinch", "status_chance":30 },
				{ "name":"Hurricane",  "power":110, "type":8,  "accuracy":70,  "status":"confusion", "status_chance":20 }
			]
		"pig":
			return [
				{ "name":"Tackle",     "power":50,  "type":13, "accuracy":95 },
				{ "name":"Bulldoze",   "power":60,  "type":11, "accuracy":100, "status":"speed_down", "status_chance":100 },
				{ "name":"Rollout",    "power":30,  "type":16, "accuracy":90 }
			]
		"slimer":
			return [
				{ "name":"Sludge",     "power":65,  "type":14, "accuracy":100, "status":"poison", "status_chance":30 },
				{ "name":"Shadow Punch","power":60, "type":9,  "accuracy":100 },
				{ "name":"Acid Armor", "power":0,   "type":14, "accuracy":100, "status":"defense_buff", "status_chance":100 }
			]
		"dragon":
			return [
				{ "name":"Dragon Breath","power":60,"type":3,  "accuracy":100, "status":"burn", "status_chance":20 },
				{ "name":"Outrage",     "power":120, "type":3,  "accuracy":85 },
				{ "name":"Sky Drop",    "power":60,  "type":8,  "accuracy":75 }
			]
		"froggy":
			return [
				{ "name":"Hydro Pump",  "power":110, "type":18, "accuracy":80 },
				{ "name":"Ice Beam",    "power":90,  "type":12, "accuracy":100, "status":"freeze", "status_chance":10 },
				{ "name":"Double Kick", "power":30,  "type":6,  "accuracy":100, "hits":2 }
			]
		"mushroom":
			return [
				{ "name":"Spore",       "power":0,   "type":12, "accuracy":100, "status":"sleep", "status_chance":100 },
				{ "name":"Giga Drain",  "power":75,  "type":13, "accuracy":100, "status":"heal", "status_chance":100 },
				{ "name":"Stun Spore",  "power":0,   "type":1,  "accuracy":75,  "status":"paralysis", "status_chance":100 }
			]
		"vulture":
			return [
				{ "name":"Pluck",      "power":60,  "type":13, "accuracy":100 },
				{ "name":"Poison Wing","power":75,  "type":14, "accuracy":90,  "status":"poison", "status_chance":30 },
				{ "name":"Fly",        "power":90,  "type":8,  "accuracy":95 }
			]
		"winterfox":
			return [
				{ "name":"Ice Shard",  "power":40,  "type":12, "accuracy":100, "priority":1 },
				{ "name":"Blizzard",   "power":110, "type":12, "accuracy":70,  "status":"freeze", "status_chance":10 },
				{ "name":"Play Rough", "power":90,  "type":5,  "accuracy":90 }
			]
		"yeti":
			return [
				{ "name":"Ice Punch",  "power":75,  "type":12, "accuracy":100, "status":"freeze", "status_chance":10 },
				{ "name":"Hammer Arm", "power":100, "type":13, "accuracy":90,  "status":"speed_down", "status_chance":100 },
				{ "name":"Earthquake", "power":100, "type":11, "accuracy":85 }
			]
		_:
			push_error("Invalid enemy name: " + enemy_name)
			return [
				{ "name":"Tackle",   "power":50, "type":13, "accuracy":95 },
				{ "name":"Growl",    "power":0,  "type":13, "accuracy":100, "status":"attack_down", "status_chance":100 }
			]
