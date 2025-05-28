extends Node2D

#deck storage
#drawn card = 0

func _ready() -> void:
	pass
	#set drawn card to true (goes first, can't draw card)
	#shuffle deck

func _process(delta: float) -> void:
	pass

#function draw card
	#draws one card
	#place card in hand
	#set drawn card to true (only once per turn)
	#remove from deck storage
