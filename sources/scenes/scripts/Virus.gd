extends Node

class_name Virus

var id: int
var virus: String
var type: int
var rarity: int
var price: float

func _to_string() -> String:
	return 'ID: ' + str(id) + '\n	Name: ' + str(virus) + \
	'\n	Type: ' + str(type) + '\n	Rarity: ' + str(rarity) + '\n'
