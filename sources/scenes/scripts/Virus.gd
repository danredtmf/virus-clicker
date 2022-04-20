extends Node

class_name Virus

var virus_name: String
var type: int
var rarity: int

func _to_string():
	return 'Name: ' + str(virus_name) + ':\n	Type: ' + str(type) + '\n	Rarity: ' + str(rarity)
