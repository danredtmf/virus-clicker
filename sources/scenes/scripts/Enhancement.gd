extends Node

class_name Enhancement

# enh_way - Что изменяет улучшение
# enh_inc - Изменение
var id: int
var enhancement: String
var lvl: int = 0
var price: float
var enh_way: int
var enh_inc: float

func _to_string() -> String:
	return 'ID: ' + str(id) + '\n	Name: ' + str(enhancement) + \
	'\n	Lvl: ' + str(lvl) + '\n	Price: ' + str(price) + \
	'\n	Enh Way: ' + str(enh_way) + '\n	Enh Inc: ' + str(enh_inc)
