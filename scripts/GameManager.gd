extends Node


@export var yokai_illusts:Array[Texture2D] #6種類
@export var cards: Array[Container] #12個
@export var shippai_num: Label
#@onready var shippai_num: Label = $shippai_num
#export var is_initialised: bool = false

var card_slot:Array[Container]
var order = [0,1,2,3,4,5,0,1,2,3,4,5]
#var order = [0,1,2,3,4,5,0,1,2,3,4,5, 0,0,4,4]

var shippai:int



func _ready() -> void:
	GenerateDeck()
	pass
	

func GenerateDeck():
	order.shuffle()
	for i in cards.size():
		var yokai_number = order[i]
		var path = yokai_illusts[yokai_number].resource_path
		cards[i].load_cardface(path)
		cards[i].yokai_number = yokai_number



func set_card_to_slot(child_scene):
	
	if child_scene.faceup == false:

		if card_slot.size() == 0:
			child_scene.flip_card()
			card_slot.append(child_scene)
		elif card_slot.size() == 1:
			child_scene.flip_card()
			card_slot.append(child_scene)
			check_yokai_number()	
	
		
func check_yokai_number():
	if card_slot[0].yokai_number == card_slot[1].yokai_number:	
		card_slot = []
		await get_tree().create_timer(0.3).timeout
		Audio.get_node("pirorin").play()
	else:
		await get_tree().create_timer(1.0).timeout
		card_slot[0].call_deferred("flip_back_card")
		card_slot[1].call_deferred("flip_back_card")
		card_slot = []
		shippai += 1
		#print(shippai)
		shippai_num.text = str(shippai)
		Audio.get_node("boo").play()


func reset_game():
	Audio.get_node("pyoro").play()
	for i in cards.size():
		if cards[i].faceup == true:
			cards[i].faceup = false
			cards[i].flip_back_card()
			await get_tree().create_timer(0.02).timeout

	card_slot = []
	shippai = 0
	shippai_num.text = str(0)
	

func _on_reset_pressed() -> void:
	reset_game()
	await get_tree().create_timer(1.0).timeout
	GenerateDeck()


func _on_shuryo_pressed() -> void:
	get_tree().quit()


func _on_reset_mouse_entered() -> void:
	Audio.get_node("kiko").play()
	

func _on_shuryo_mouse_entered() -> void:
	Audio.get_node("kiko").play()
