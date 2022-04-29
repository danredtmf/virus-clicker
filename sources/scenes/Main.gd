extends Control

const QUIT_ACCEPT_RES = preload("res://sources/scenes/objects/quit_accept.tscn")

func _ready():
	Core.gen_enh_panel($margin/vb/vb_btn/scroll/grid_enh)

func _process(_delta):
	$margin/vb/hb/money.text = \
		"Money: " + Core.get_suffix_value(DataBase.db_user.money)
	$margin/vb/hb/exp.text = \
		"Exp: " + Core.get_suffix_value(DataBase.db_user.experience)
	
	$margin/vb/vb_btn/i1.text = '-' + Core.get_suffix_value(DataBase.EXP_ATTEMPT) + ' exp (' +  str(DataBase.ATTEMPT) + ' virus)'
	$margin/vb/vb_btn/i10.text = '-' + Core.get_suffix_value(DataBase.EXP_ATTEMPTS) + ' exp (' +  str(DataBase.ATTEMPTS) + ' viruses)'

func _on_Button_pressed():
	DataBase.db_user.add_experience()

func _on_i1_pressed():
	if DataBase.db_user.spend_experience(DataBase.EXP_ATTEMPT):
		var list: Dictionary = Core.gen_items_and_money()
		DataBase.db_user.add_money(list["money"])

func _on_i10_pressed():
	if DataBase.db_user.spend_experience(DataBase.EXP_ATTEMPTS):
		var list: Dictionary = Core.gen_items_and_money(DataBase.ATTEMPTS)
		DataBase.db_user.add_money(list["money"])

func _notification(what):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			var quit = QUIT_ACCEPT_RES.instance()
			get_tree().root.call_deferred("add_child", quit)
		NOTIFICATION_WM_GO_BACK_REQUEST:
			var quit = QUIT_ACCEPT_RES.instance()
			get_tree().root.call_deferred("add_child", quit)
