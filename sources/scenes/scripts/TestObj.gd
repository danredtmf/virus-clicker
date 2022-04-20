extends Node

enum VIRUS_TYPE { HARMLESS, DANGEROUS, DESTRUCTIVE }

enum VIRUS_RARITY { STAR_1, STAR_2, STAR_3, STAR_4, STAR_5 }

var s1_list = []
var s2_list = []
var s3_list = []
var s4_list = []
var s5_list = []

var list: Array = []

var s1: int = 0
var s2: int = 0
var s3: int = 0
var s4: int = 0
var s5: int = 0

var h: int = 0
var da: int = 0
var de: int = 0

var m: float = 0 # money
var e: float = 0 # exp

var c: float = 0 # attempt chance
var all_s: int = 0 # all attempts
var s: int = 0 # s5 attempt moment

func _ready():
	randomize()
	create_objects()
#	loading()
	attepts()
#	saving()
	get_tree().quit()

func loading():
	var conf = ConfigFile.new()
	
	var l = conf.load_encrypted_pass('res://data.save', 'pass')
	if l == OK:
		s1_list = conf.get_value('data', 's1_list')
		s2_list = conf.get_value('data', 's2_list')
		s3_list = conf.get_value('data', 's3_list')
		s4_list = conf.get_value('data', 's4_list')
		s5_list = conf.get_value('data', 's5_list')

		list = conf.get_value('data', 'list')

		s1 = conf.get_value('data', 's1')
		s2 = conf.get_value('data', 's2')
		s3 = conf.get_value('data', 's3')
		s4 = conf.get_value('data', 's4')
		s5 = conf.get_value('data', 's5')

		h = conf.get_value('data', 'h')
		da = conf.get_value('data', 'da')
		de = conf.get_value('data', 'de')

		m = conf.get_value('data', 'm')
		e = conf.get_value('data', 'e')

		c = conf.get_value('data', 'c')
		all_s = conf.get_value('data', 'all_s')
		s = conf.get_value('data', 's')
	elif l == ERR_FILE_NOT_FOUND:
		create_objects()

func attepts():
	for _aa in range(1):
		for _i in range(10):
			e += 160
			all_s += 1
			s += 1
			
			var v: Virus = null
			
			while v == null:
				v = pull()
			
			list.append(v)
	
	var result = "S1: " + str(s1) + "\nS2: " + str(s2) + "\nS3: " + str(s3) + "\nS4: " + str(s4) + "\nS5: " + str(s5) + "\n\nH: " + str(h) + "\nDA: " + str(da) + "\nDE: " + str(de) + "\n\nM: " + str(m) + "\nE: " + str(e)
	
	print(result)

func pull():
	var r_c = 1.1 if s % 10 == 0 && s % 90 != 0 \
		else 0.1 if s % 90 == 0 \
		else rand_range(0, 2) if s % 76 == 0 \
		else rand_range(0, 4) if s % 77 == 0 \
		else rand_range(0, 6) if s % 78 == 0 \
		else rand_range(0, 8) if s % 79 == 0 \
		else rand_range(0, 10) if s % 80 == 0 \
		else rand_range(0, 12) if s % 81 == 0 \
		else rand_range(0, 14) if s % 82 == 0 \
		else rand_range(0, 16) if s % 83 == 0 \
		else rand_range(0, 100)
	
	var r = VIRUS_RARITY.STAR_1 if r_c > 20 \
		else VIRUS_RARITY.STAR_2 if r_c < 20 && r_c > 10 \
		else VIRUS_RARITY.STAR_3 if r_c < 10 && r_c > 5 \
		else VIRUS_RARITY.STAR_4 if r_c < 5 && r_c > 1 \
		else VIRUS_RARITY.STAR_5
	
	var v: Virus
	
	match r:
		VIRUS_RARITY.STAR_1:
			v = s1_list[randi() % s1_list.size()] if s1_list.size() != 0 \
				else null
			
			if v == null: return v
			
			s1 += 1
			m += 1
		VIRUS_RARITY.STAR_2:
			v = s2_list[randi() % s2_list.size()] if s2_list.size() != 0 \
				else null
			
			if v == null: return v
			
			s2 += 1
			m += 3
		VIRUS_RARITY.STAR_3:
			v = s3_list[randi() % s3_list.size()] if s3_list.size() != 0 \
				else null
			
			if v == null: return v
			
			s3 += 1
			m += 6
		VIRUS_RARITY.STAR_4:
			v = s4_list[randi() % s4_list.size()] if s4_list.size() != 0 \
				else null
			
			if v == null: return v
			
			s4 += 1
			m += 9
		VIRUS_RARITY.STAR_5:
			v = s5_list[randi() % s5_list.size()] if s5_list.size() != 0 \
				else null
			
			if v == null: return v
			
			s5 += 1
			m += 15
			print("S5 Attept: ", s, " (chance: ", r_c, ")\n-")
			s = 0
	
	var t = v.type
	
	match t:
		VIRUS_TYPE.HARMLESS:
			h += 1
			m += 1
		VIRUS_TYPE.DANGEROUS:
			da += 1
			m += 5
		VIRUS_TYPE.DESTRUCTIVE:
			de += 1
			m += 10
	
	return v

func saving():
	var conf = ConfigFile.new()
	
	conf.set_value('data', 's1_list', s1_list)
	conf.set_value('data', 's2_list', s2_list)
	conf.set_value('data', 's3_list', s3_list)
	conf.set_value('data', 's4_list', s4_list)
	conf.set_value('data', 's5_list', s5_list)
	
	conf.set_value('data', 'list', list)
	
	conf.set_value('data', 's1', s1)
	conf.set_value('data', 's2', s2)
	conf.set_value('data', 's3', s3)
	conf.set_value('data', 's4', s4)
	conf.set_value('data', 's5', s5)
	
	conf.set_value('data', 'h', h)
	conf.set_value('data', 'da', da)
	conf.set_value('data', 'de', de)
	
	conf.set_value('data', 'm', m)
	conf.set_value('data', 'e', e)
	
	conf.set_value('data', 'c', c)
	conf.set_value('data', 'all_s', all_s)
	conf.set_value('data', 's', s)
	
	conf.save_encrypted_pass('res://data.save', 'pass')
	
	get_tree().quit()

func create_objects():
	for i in range(10):
		for n in range(10):
			var v = Virus.new()
			var v_n = str(i) + str(n)
			
			v.virus_name = v_n.hash()
			
			var t = randi() % VIRUS_TYPE.size()
			
			v.type = VIRUS_TYPE.values()[t]
			
			var r = randi() % VIRUS_RARITY.size()
			v.rarity = VIRUS_RARITY.values()[r]
			
			match v.rarity:
				VIRUS_RARITY.STAR_1:
					s1_list.append(v)
				VIRUS_RARITY.STAR_2:
					s2_list.append(v)
				VIRUS_RARITY.STAR_3:
					s3_list.append(v)
				VIRUS_RARITY.STAR_4:
					s4_list.append(v)
				VIRUS_RARITY.STAR_5:
					s5_list.append(v)
	
	print('s1_l: ', s1_list.size())
	print('s2_l: ', s2_list.size())
	print('s3_l: ', s3_list.size())
	print('s4_l: ', s4_list.size())
	print('s5_l: ', s5_list.size())
	print('-')
