extends Control

func _process(_delta):
	$margin/vb/hb/money.text = \
		"Money: " + Core.get_suffix_value(DataBase.db_user.money)
	$margin/vb/hb/exp.text = \
		"Exp: " + Core.get_suffix_value(DataBase.db_user.experience)

func _on_Button_pressed():
	DataBase.db_user.add_experience()

func _on_i1_pressed():
	if DataBase.db_user.spend_experience(0.160):
		var list: Dictionary = Core.gen_items_and_money()
		DataBase.db_user.add_money(list["money"])

func _on_i10_pressed():
	if DataBase.db_user.spend_experience(1.600):
		var list: Dictionary = Core.gen_items_and_money(10)
		DataBase.db_user.add_money(list["money"])
