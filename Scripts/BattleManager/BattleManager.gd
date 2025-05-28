extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#player and opponent lore to zero, set the text to 0
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#end turn function
	#on end turn pressed, switch to other player's turn

#quest function
	#add correct amount of lore and change text
	#exert card

#attack function
	#select card when attacking
	#can only select exerted cards
	#exchange damage
	#exert or banish card(s)

#banish function
	#move card to discard and flip over
	#add the back of card picture when first discard card is added
	#store cards that are in the discard (incase we need to pull one out)

#ink card function
	#move card to inkwell and flip over
	#add the back of card picture when first inked card is added
	#can only ink if card is able to be inked
	#store total number of inked cards (resets every round), don't need to store cards
	
#exert card function
	#turn card sideways
	#change exerted variable to true
