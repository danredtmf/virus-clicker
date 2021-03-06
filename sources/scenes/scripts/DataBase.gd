extends Node

const ATTEMPT : int = 1
const ATTEMPTS : int = ATTEMPT * 9

const EXP_ATTEMPT : float = 0.160
const EXP_ATTEMPTS : float = EXP_ATTEMPT * 9

var db_enhancements: DBEnhancements = DBEnhancements.new()
var db_viruses: DBViruses = DBViruses.new()
var db_stats: DBStats = DBStats.new()
var db_user: DBUser = DBUser.new()

func _ready():
	var _temp = OS.request_permissions()
	var _permissions: Array = OS.get_granted_permissions()

# Хранение списка улучшений по умолчанию
class DBEnhancements:
	# EPC - Experience Per Click
	# СEPC - Crit. Experience Per Click
	# СCEPC - Crit. Chance Experience Per Click
	enum ENH_WAY { EPC, CEPC, CCEPC }
	
	var _list_enhancements: Array = []
	
	func _init():
		_gen_items()
	
	func _load_names() -> Dictionary:
		var file: File = File.new()
		var result: Dictionary
		var data
		
		var l = file.open("res://sources/data/enhs.json", File.READ)
		if l == OK:
			data = parse_json(file.get_as_text())
			if typeof(data) == TYPE_DICTIONARY:
				result = data
		
		return result
	
	func _gen_items() -> void:
		var names: Dictionary = _load_names()
		
		for i in range(names.size()):
			var e: Enhancement = Enhancement.new()
			e.id = i
			e.enhancement = names.keys()[i]
			
			e.price = gen_price(names.values()[i]["price"])
			e.enh_way = names.values()[i]["enh_way"]
			
			e.enh_inc = gen_enh_inc(names.values()[i]["enh_inc"], e.enh_way)
			
			_list_enhancements.append(e)
	
	func gen_price(value: float, lvl: int = 0) -> float:
		var new_price: float = 0
		
		if lvl == 0:
			new_price = value
		else:
			new_price = ((value / 100) * 25) + value
		
		return new_price
	
	func gen_enh_inc(value: float, enh_way: int) -> float:
		var new_value: float = 0
		
		if enh_way == ENH_WAY.CEPC || enh_way == ENH_WAY.CCEPC:
			new_value = ((value / 100) * 15) + value
		elif enh_way == ENH_WAY.EPC:
			new_value = value
		
		return new_value
	
	func set_enh_inc(value: float, enh_way: int) -> void:
		match enh_way:
			DBEnhancements.ENH_WAY.EPC:
				DataBase.db_user.EPC += value
			DBEnhancements.ENH_WAY.CEPC:
				DataBase.db_user.CEPC = value
			DBEnhancements.ENH_WAY.CCEPC:
				DataBase.db_user.CCEPC = value

# Хранение списка вирусов
class DBViruses:
	const VIRUS_PRICE_ONE_ATTEMPT: float = 0.160
	const VIRUS_PRICE_FIVE_ATTEMPT: float = VIRUS_PRICE_ONE_ATTEMPT * 5
	
	enum VIRUS_TYPE { HARMLESS, DANGEROUS, DESTRUCTIVE }
	enum VIRUS_RARITY { STAR_1, STAR_2, STAR_3, STAR_4, STAR_5 }
	
	var _list_viruses: Array = []
	
	func _init():
		_gen_items()
	
	func gen(iterations: int = 1) -> Array:
		var array: Array = []
		
		for _i in range(iterations):
			DataBase.db_stats.add_attempt()
			var virus: Virus = _list_viruses[randi() % _list_viruses.size()]
			
			virus.rarity = \
			_gen_rarity(_get_random_chance(DataBase.db_stats.current_attempt))
			
			virus.price = _get_price(virus)
			
			array.append(virus)
		
		return array
	
	func _load_names() -> Dictionary:
		var file: File = File.new()
		var result: Dictionary
		var data
		
		var l = file.open("res://sources/data/viruses.json", File.READ)
		if l == OK:
			data = parse_json(file.get_as_text())
			if typeof(data) == TYPE_DICTIONARY:
				result = data
		
		return result
	
	func _gen_items() -> void:
		var names: Dictionary = _load_names()
		
		for i in range(names.size()):
			var v: Virus = Virus.new()
			v.id = i
			v.virus = names.keys()[i]
			v.type = names.values()[i]["type"]
			
			_list_viruses.append(v)
	
	func _gen_rarity(chance: float) -> int:
		var rarity: int = VIRUS_RARITY.STAR_1 if chance > 20 \
			else VIRUS_RARITY.STAR_2 if chance < 20 && chance > 10 \
			else VIRUS_RARITY.STAR_3 if chance < 10 && chance > 5 \
			else VIRUS_RARITY.STAR_4 if chance < 5 && chance > 1 \
			else VIRUS_RARITY.STAR_5
		
		if rarity == VIRUS_RARITY.STAR_5:
			DataBase.db_stats.clear_current_attempt()
		
		return rarity
	
	func _get_random_chance(current_attempt: int) -> float:
		var chance: float = 1.1 if current_attempt % 10 == 0 \
									&& current_attempt % 90 != 0 \
			else 0.1 if current_attempt % 90 == 0 \
			else rand_range(0, 2) if current_attempt % 76 == 0 \
			else rand_range(0, 4) if current_attempt % 77 == 0 \
			else rand_range(0, 6) if current_attempt % 78 == 0 \
			else rand_range(0, 8) if current_attempt % 79 == 0 \
			else rand_range(0, 10) if current_attempt % 80 == 0 \
			else rand_range(0, 12) if current_attempt % 81 == 0 \
			else rand_range(0, 14) if current_attempt % 82 == 0 \
			else rand_range(0, 16) if current_attempt % 83 == 0 \
			else rand_range(0, 100)
		
		return chance
	
	func _get_price(virus: Virus) -> float:
		var money: float = 0
		
		var v: Virus = virus
		
		match v.type:
			DataBase.DBViruses.VIRUS_TYPE.HARMLESS:
				money += 1
			DataBase.DBViruses.VIRUS_TYPE.DANGEROUS:
				money += 4
			DataBase.DBViruses.VIRUS_TYPE.DESTRUCTIVE:
				money += 8

		match v.rarity:
			DataBase.DBViruses.VIRUS_RARITY.STAR_1:
				money += 1
			DataBase.DBViruses.VIRUS_RARITY.STAR_2:
				money += 2
			DataBase.DBViruses.VIRUS_RARITY.STAR_3:
				money += 4
			DataBase.DBViruses.VIRUS_RARITY.STAR_4:
				money += 6
			DataBase.DBViruses.VIRUS_RARITY.STAR_5:
				money += 8
		
		return money

# Хранение статистики
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
	
	func _init():
		loading()
	
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
		
		conf.save(OS.get_user_data_dir()+"/stats")
		
		print(OS.get_user_data_dir())
	
	func loading() -> void:
		var conf = ConfigFile.new()
		
		var l = conf.load(OS.get_user_data_dir()+"/stats")
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
	
	func add_attempt() -> void:
		_add_current_attempt()
		_add_total_attempts()
	
	func _add_current_attempt() -> void:
		current_attempt += 1
	
	func _add_total_attempts() -> void:
		total_attempts += 1
	
	func clear_current_attempt() -> void:
		current_attempt = 0

# Хранение данных пользователя
class DBUser:
	var money: float = 0
	var experience: float = 0
	
	# EPC - Experience Per Click
	# СEPC - Crit. Experience Per Click
	# СCEPC - Crit. Chance Experience Per Click
	var EPC: float = 0.001
	var CEPC: float = 0.02
	var CCEPC: float = 0.01
	
	var changed_enhancements: Array = []
	var opened_viruses_id: Array = []
	
	func _init():
		loading()
	
	func saving() -> void:
		var conf = ConfigFile.new()
		
		conf.set_value('user', 'm', money)
		conf.set_value('user', 'e', experience)
		
		conf.set_value('user', 'epc', EPC)
		conf.set_value('user', 'cepc', CEPC)
		conf.set_value('user', 'ccepc', CCEPC)
		
		conf.set_value('user', 'ce', changed_enhancements)
		conf.set_value('user', 'ovi', opened_viruses_id)
		
		conf.save(OS.get_user_data_dir()+"/user")
	
	func loading() -> void:
		var conf = ConfigFile.new()
		
		var l = conf.load(OS.get_user_data_dir()+"/user")
		if l == OK:
			money = conf.get_value('user', 'm')
			experience = conf.get_value('user', 'e')
			
			EPC = conf.get_value('user', 'epc')
			CEPC = conf.get_value('user', 'cepc')
			CCEPC = conf.get_value('user', 'ccepc')
			
			changed_enhancements = conf.get_value('user', 'ce')
			opened_viruses_id = conf.get_value('user', 'ovi')
	
	func add_money(value: float) -> void:
		money += value
	
	# считает монеты после генерации вирусов
	func get_money(viruses: Array) -> float:
		var new_money: float = 0
		
		for i in viruses:
			var virus: Virus = i
			
			new_money += virus.price
		
		return new_money
	
	func check_money(value: float) -> bool:
		if money >= value:
			return true
		else:
			return false
	
	func spend_money(value: float) -> void:
		money -= value
	
	func add_experience() -> void:
		if _check_chance_experience():
			if CEPC < 1:
				experience += ((EPC / 100) * (CEPC * 100)) + EPC
			else:
				experience += ((EPC / 100) * CEPC) + EPC
			print("CRIT MOMENT")
		else:
			experience += EPC
	
	func spend_experience(value: float) -> bool:
		if experience >= value:
			experience -= value
			return true
		else:
			return false
	
	func add_EPC(value: float) -> void:
		EPC += value
	
	func _check_chance_experience() -> bool:
		var chance: float = _get_random_chance()
		
		if CCEPC >= chance:
			return true
		else:
			return false
	
	func _get_random_chance() -> float:
		var chance: float = rand_range(0, 100)
		
		return chance
