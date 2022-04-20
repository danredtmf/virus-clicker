extends Node

class_name DataBase

var db_enhancements: DBEnhancements = DBEnhancements.new()
var db_viruses: DBViruses = DBViruses.new()
var db_stats: DBStats = DBStats.new()
var db_user: DBUser = DBUser.new()

class DBEnhancements:
	# EPC - Experience Per Click
	# СEPC - Crit. Experience Per Click
	# СEPC - Crit. Chance Experience Per Click
	enum ENH_WAY { EPC, CEPC, CCEPC }
	
	class Enhancements:
		# enh_way - Что изменяет улучшение
		# enh_inc - 
		var id: int
		var enhancement: String
		var lvl: int
		var price: float
		var enh_way: int
		var enh_inc: float

class DBViruses:
	enum VIRUS_TYPE { HARMLESS, DANGEROUS, DESTRUCTIVE }
	enum VIRUS_RARITY { STAR_1, STAR_2, STAR_3, STAR_4, STAR_5 }
	
	var list_names: Array = ['Yoki-417', 'Yoki-1193']
	var list_viruses: Array = []
	
	func _init():
		gen_items()
	
	class Virus:
		var id: int
		var virus: String
		var type: int
		var rarity: int
		var price: int

		func _to_string() -> String:
			return 'ID: ' + str(id) + '\n	Name: ' + str(virus) + '\n	Type: ' + str(type) + '\n	Rarity: ' + str(rarity) + '\n'
	
	func gen_items() -> void:
		for i in range(list_names.size()):
			var v: Virus = Virus.new()
			v.id = i
			v.virus = list_names[i]
			
			list_viruses.append(v)

class DBStats:
	var total_s1_items: int
	var total_s2_items: int
	var total_s3_items: int
	var total_s4_items: int
	var total_s5_items: int
	
	var total_harmless_items: int
	var total_dangerous_items: int
	var total_destructive_items: int
	
	var total_attempts: int
	var current_attempt: int
	
	func saving() -> void:
		var conf = ConfigFile.new()
		
		conf.set_value('stats', 'ts1i', total_s1_items)
		conf.set_value('stats', 'ts2i', total_s2_items)
		conf.set_value('stats', 'ts3i', total_s3_items)
		conf.set_value('stats', 'ts4i', total_s4_items)
		conf.set_value('stats', 'ts5i', total_s5_items)
		
		conf.set_value('stats', 'thi', total_harmless_items)
		conf.set_value('stats', 'tdai', total_dangerous_items)
		conf.set_value('stats', 'tdei', total_destructive_items)
		
		conf.set_value('stats', 'ta', total_attempts)
		conf.set_value('stats', 'ca', current_attempt)
		
		conf.save("user://stats")
	
	func loading() -> void:
		var conf = ConfigFile.new()
		
		var l = conf.load("user://stats")
		if l == OK:
			total_s1_items = conf.get_value('stats', 'ts1i')
			total_s2_items = conf.get_value('stats', 'ts2i')
			total_s3_items = conf.get_value('stats', 'ts3i')
			total_s4_items = conf.get_value('stats', 'ts4i')
			total_s5_items = conf.get_value('stats', 'ts5i')
			
			total_harmless_items = conf.get_value('stats', 'thi')
			total_dangerous_items = conf.get_value('stats', 'tdai')
			total_destructive_items = conf.get_value('stats', 'tdei')
			
			total_attempts = conf.get_value('stats', 'ta')
			current_attempt = conf.get_value('stats', 'ca')

class DBUser:
	var money: float
	var experience: float
	
	var EPC: float = 0.1
	var CEPC: float = 0.03
	var CCEPC: float = 0.01
