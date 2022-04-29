extends PanelContainer

var id: int

func _ready():
	show_info()

func show_info():
	$vb/info.text = Core.show_enh(id)

func _on_buy_pressed():
	Core.buy_enh(id)
	show_info()
