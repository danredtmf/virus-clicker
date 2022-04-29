extends Node

const ENH_PANEL_RES = preload("res://sources/scenes/objects/enh_panel.tscn")

func gen_enh_panel(ui_list: Node) -> void:
	var arr_id: Array = get_enh_id_list()
	
	var panel
	for id in arr_id:
		panel = ENH_PANEL_RES.instance()
		panel.id = id
		ui_list.add_child(panel)

# вывод списка id улучшений
func get_enh_id_list() -> Array:
	var arr: Array = []
	
	for e in DataBase.db_enhancements._list_enhancements:
		if e is Enhancement:
			arr.append(e.id)
	
	return arr

# вывод индекса улучшения в массиве
func get_enh_index(enh_id: int, list: Array) -> int:
	var result: int = -1
	
	for e in list.size():
		if list[e] is Enhancement:
			if list[e].id == enh_id:
				result = e
				break
	
	return result

# вывод улучшения из массива
# если услучшение есть
func get_enh(enh_id: int) -> Enhancement:
	var arr: Array
	var new_enh: Enhancement
	
	var state = 0
	
	while (state >= 0):
		if state == 0:
			if not DataBase.db_user.changed_enhancements.empty():
				arr = DataBase.db_user.changed_enhancements.duplicate()
				
				for e in arr:
					if e is Enhancement:
						if e.id == enh_id:
							new_enh = e
							state = -1
							break
				
				if new_enh == null: state = 1
			else:
				state = 1
		elif state == 1:
			if not DataBase.db_enhancements._list_enhancements.empty():
				arr = DataBase.db_enhancements._list_enhancements.duplicate()
				
				for e in arr:
					if e is Enhancement:
						if e.id == enh_id:
							new_enh = e
							state = -1
							break
				
				if new_enh == null: state = -1
			else:
				state = -1
	
	return new_enh

# показ информации об улучшении
func show_enh(enh_id: int) -> String:
	var new_enh : Enhancement = get_enh(enh_id)
	var result: String
	
	if new_enh is Enhancement:
		if new_enh.lvl < 60:
			result = str(new_enh.enhancement) + '\nMoney: ' + get_suffix_value(new_enh.price) + ' Lvl: ' + str(new_enh.lvl) + ' (+' + str(new_enh.enh_inc) + 'exp)'
		else:
			result = str(new_enh.enhancement) + '\nLvl: ' + str(new_enh.lvl) + ' MAX (+' + str(new_enh.enh_inc) + 'exp)'
	
	return result

# покупка улучшения
func buy_enh(enh_id: int) -> void:
	var new_enh := get_enh(enh_id)
	var e := Enhancement.new()
	e.id = enh_id
	
	if DataBase.db_user.check_money(new_enh.price) && new_enh.lvl == 0:
		DataBase.db_user.spend_money(new_enh.price)
		new_enh.lvl += 1
		new_enh.price = DataBase.db_enhancements.gen_price(new_enh.price, new_enh.lvl)
		new_enh.enh_inc = DataBase.db_enhancements.gen_enh_inc(new_enh.enh_inc, new_enh.enh_way)
		
		DataBase.db_enhancements.set_enh_inc(new_enh.enh_inc, new_enh.enh_way)
		
		DataBase.db_user.changed_enhancements.append(new_enh)
	elif DataBase.db_user.check_money(new_enh.price) && new_enh.lvl < 60:
		DataBase.db_user.spend_money(new_enh.price)
		new_enh.lvl += 1
		new_enh.price = DataBase.db_enhancements.gen_price(new_enh.price, new_enh.lvl)
		new_enh.enh_inc = DataBase.db_enhancements.gen_enh_inc(new_enh.enh_inc, new_enh.enh_way)
		
		DataBase.db_enhancements.set_enh_inc(new_enh.enh_inc, new_enh.enh_way)
		
		DataBase.db_user.changed_enhancements.remove(get_enh_index(enh_id, DataBase.db_user.changed_enhancements))
		DataBase.db_user.changed_enhancements.append(new_enh)

# генерация вирусов и подсчёт монет
func gen_items_and_money(gen_iterations: int = 1) -> Dictionary:
	var viruses: Array = DataBase.db_viruses.gen(gen_iterations)
	var money: float = DataBase.db_user.get_money(viruses)
	
	var result: Dictionary = {
		"viruses": viruses,
		"money": money,
	}
	
	return result

# вывод суммы с суффиксом
func get_suffix_value(value: float) -> String:
	var zero: int = 0
	
	while (value >= 1000):
		zero += 1
		
		value /= 1000
	
	var suffix: String = ''
	
	match zero:
		1:
			suffix = "K"
		2:
			suffix = "M"
		3:
			suffix = "B"
		4:
			suffix = "T"
		5:
			suffix = "Qd"
		6:
			suffix = "Qn"
		7:
			suffix = "Sx"
		8:
			suffix = "Sp"
		9:
			suffix = "Oc"
	
	var result: String
	
	result = str(stepify(value, 0.001)) + suffix
	
	return result

# сохранение данных
func exit() -> void:
	DataBase.db_stats.saving()
	DataBase.db_user.saving()
