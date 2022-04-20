extends Node

func _ready():
	var _db: DataBase = DataBase.new()
	
	var p: float = 200
	var e: float = 0.001
	var ce: float = 0.01
	var cre: float = 0.02
	
	print(str(((e / 100) * (cre * 100)) + e))
	
	for i in range(60):
		p = ((p / 100) * 25) + p
		e = ((e / 100) * 25) + e
		ce = ((ce / 100) * 15) + ce
		cre = ((cre / 100) * 15) + cre
	
	print("CE: ", get_suffix_value(ce) + " %")
	print("CRE: ", get_suffix_value(cre) + " %")
	print("E: ", get_suffix_value(e))
	print("M: ", get_suffix_value(p))
	
	print(str(((e / 100) * cre) + e))
	
	get_tree().quit()

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
