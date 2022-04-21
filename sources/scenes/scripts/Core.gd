extends Node

func gen_items_and_money(gen_iterations: int = 1) -> Dictionary:
	var viruses: Array = DataBase.db_viruses.gen(gen_iterations)
	var money: float = DataBase.db_user.get_money(viruses)
	
	var result: Dictionary = {
		"viruses": viruses,
		"money": money,
	}
	
	return result

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
	
	var result: String = str(stepify(value, 0.001)) + suffix
	
	return result

func exit() -> void:
	DataBase.db_stats.saving()
	DataBase.db_user.saving()
