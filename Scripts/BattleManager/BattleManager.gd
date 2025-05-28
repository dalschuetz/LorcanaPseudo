extends Node

func _ready() -> void:
	#player and opponent lore to zero, set the text to 0
	#player end turn button appear, opponent end turn button invisible
	pass


func _process(delta: float) -> void:
	pass

#end turn function
	#check if previous has 20 lore, end game if so
		#else
			#set drawn card for next player to false (allow to draw card)
			#set inked card for next player to false (allow to ink a new card)
			#allow next player to interact with cards
			#set next player's ink to total ink
			#have next player's end turn button appear
			#have the previous player's end turn button disappear

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
