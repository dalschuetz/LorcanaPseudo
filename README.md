# Lorcana Game Development - Complete Godot 4.4 Project Structure

## Detailed File Tree with Implementation Comments

```
LorcanaGame/
├── project.godot                   
│   # Main Scene: scenes/main.tscn (set in Project Settings)
│   # Autoloads configured:
│   #   - GameManager: src/game_manager.gd
│   #   - CardDatabase: src/card_database.gd  
│   #   - DeckManager: src/deck_manager.gd
│   # Resolution: 1920x1080, Renderer: Forward+
│
├── scenes/
│   ├── main.tscn                   
│   │   # Root: Main (Node) - persistent entry point, never freed
│   │   # Purpose: scene management without change_scene(), data continuity
│   │   # Children: dynamically instantiated game.tscn or deck_builder.tscn
│   │   # Layout: simple container for scene switching
│   │   └── main.gd                 
│   │       # ATTACHED to main.tscn
│   │       # class_name Main extends Node
│   │       # Properties: var current_scene: Node, var transition_in_progress: bool
│   │       # Methods: start_game(), open_deck_builder(), change_scene_to(scene_path)
│   │       # Handles: smooth transitions, data passing between scenes, persistent game state
│   │       # Pattern: free old scene → load new scene → add as child → transition effects
│   │
│   ├── game/
│   │   ├── game.tscn               
│   │   │   # Root: Game (Control) with VBoxContainer layout
│   │   │   # Purpose: complete game interface and state management
│   │   │   # Children structure:
│   │   │   #   ├── OpponentArea (PlayerArea instance) - top section
│   │   │   #   ├── SharedUI (Control) - center section
│   │   │   #   │   ├── TurnIndicator (Label) - "Player 1's Turn"
│   │   │   #   │   ├── PhaseDisplay (Label) - "Play Phase"
│   │   │   #   │   └── ActionButtons (HBoxContainer)
│   │   │   #   │       ├── EndTurnButton (Button) - "End Turn"
│   │   │   #   │       ├── QuestButton (Button) - "Quest Selected"
│   │   │   #   │       └── ChallengeButton (Button) - "Challenge"
│   │   │   #   ├── YourArea (PlayerArea instance) - bottom section
│   │   │   #   └── TurnManager (TurnManager instance) - logic component
│   │   │   # Layout: opponent at top, shared controls center, player at bottom
│   │   │   └── game.gd             
│   │   │       # ATTACHED to game.tscn
│   │   │       # class_name Game extends Control
│   │   │       # Properties: var players: Array[Player] = [], var current_player_index: int = 0
│   │   │       #           var game_state: String = "playing", var winner: Player = null
│   │   │       # Node refs: @onready var opponent_area: PlayerArea = $OpponentArea
│   │   │       #           @onready var your_area: PlayerArea = $YourArea
│   │   │       #           @onready var turn_manager: TurnManager = $TurnManager
│   │   │       #           @onready var turn_indicator: Label = $SharedUI/TurnIndicator
│   │   │       # Methods: setup_game(), switch_player(), update_all_displays()
│   │   │       #         handle_card_play(card), handle_combat(attacker, target)
│   │   │       #         check_win_condition(), end_game(winner)
│   │   │       # Connects: turn_manager signals, player area events, button presses
│   │   │       # Handles: complete game flow, UI updates, win/lose conditions
│   │   │
│   │   ├── player_area.tscn        
│   │   │   # Root: PlayerArea (Control) with VBoxContainer layout
│   │   │   # Purpose: complete player game space with all zones and info
│   │   │   # Child nodes (NOT instances, actual child nodes):
│   │   │   #   ├── PlayerInfo (HBoxContainer) - player display info
│   │   │   #   │   ├── PlayerName (Label) - "Player 1" / "AI Opponent"
│   │   │   #   │   ├── LoreCounter (Label) - "Lore: 15/20"
│   │   │   #   │   └── InkCounter (Label) - "Ink: 5"
│   │   │   #   ├── HandZone (HandZone) - instantiated from template
│   │   │   #   ├── PlayZone (PlayZone) - instantiated from template
│   │   │   #   ├── DeckZone (DeckZone) - instantiated from template  
│   │   │   #   └── DiscardZone (DiscardZone) - instantiated from template
│   │   │   # Layout: info at top, hand prominent, play center, piles at sides
│   │   │   # Styling: different colors/orientations for player vs opponent
│   │   │   └── player_area.gd      
│   │   │       # ATTACHED to player_area.tscn
│   │   │       # class_name PlayerArea extends Control
│   │   │       # Properties: var associated_player: Player, var is_opponent: bool = false
│   │   │       # Zone refs: @onready var hand_zone: HandZone = $HandZone
│   │   │       #           @onready var play_zone: PlayZone = $PlayZone
│   │   │       #           @onready var deck_zone: DeckZone = $DeckZone
│   │   │       #           @onready var discard_zone: DiscardZone = $DiscardZone
│   │   │       # UI refs:   @onready var lore_counter: Label = $PlayerInfo/LoreCounter
│   │   │       #           @onready var ink_counter: Label = $PlayerInfo/InkCounter
│   │   │       # Methods: setup_for_player(player), update_lore_display(lore)
│   │   │       #         update_ink_display(ink), move_card_between_zones(card, from, to)
│   │   │       #         highlight_playable_cards(), clear_all_highlights()
│   │   │       # Signals: signal card_played(card), signal zone_clicked(zone)
│   │   │       # Handles: zone coordination, display updates, card movement validation
│   │   │
│   │   └── turn_manager.tscn       
│   │       # Root: TurnManager (Node) - pure logic component
│   │       # Purpose: phase progression and turn control
│   │       # Children: PhaseTimer (Timer) - for automatic phase advancement
│   │       # No visual components, only logic and timing
│   │       └── turn_manager.gd     
│   │           # ATTACHED to turn_manager.tscn
│   │           # class_name TurnManager extends Node
│   │           # Properties: var current_phase: GameManager.GamePhase = GameManager.GamePhase.READY
│   │           #            var turn_count: int = 0, var phase_timer: Timer
│   │           # Timer ref: @onready var phase_timer: Timer = $PhaseTimer
│   │           # Methods: start_turn(), advance_phase(), end_turn()
│   │           #         handle_ready_phase(), handle_draw_phase(), handle_play_phase()
│   │           # Signals: signal phase_changed(new_phase), signal turn_ended()
│   │           #         signal ready_phase_started(), signal draw_phase_started()
│   │           # Connects: to parent Game via signals for UI updates
│   │           # Logic: Ready (ready characters, gain ink) → Draw (draw card) → Play (actions)
│   │
│   ├── cards/
│   │   └── card.tscn               
│   │       # Root: Card (Control) with custom layout
│   │       # Purpose: universal card display for all types
│   │       # Visual nodes (conditionally shown based on card type):
│   │       #   ├── CardBackground (ColorRect) - card frame/background
│   │       #   ├── CardImage (TextureRect) - artwork loaded from URL
│   │       #   ├── CardName (Label) - card name at top
│   │       #   ├── CardCost (Label) - ink cost in corner
│   │       #   ├── StatsContainer (HBoxContainer) - character stats only
│   │       #   │   ├── StrengthLabel (Label) - "2" for characters
│   │       #   │   └── WillpowerLabel (Label) - "3" for characters  
│   │       #   ├── DamageCounter (Label) - damage taken, characters only
│   │       #   ├── EffectText (RichTextLabel) - abilities and flavor text
│   │       #   ├── ShiftCost (Label) - alternative cost for songs
│   │       #   └── InteractionArea (Area2D) - mouse detection
│   │       #       └── CollisionShape2D - interaction bounds
│   │       # States: normal, highlighted, selected, disabled, exerted
│   │       └── card.gd             
│   │           # ATTACHED to card.tscn
│   │           # class_name Card extends Control
│   │           # Properties: var card_id: String, var card_name: String, var cost: int
│   │           #            var card_type: GameManager.CardType, var strength: int = 0
│   │           #            var willpower: int = 0, var damage_taken: int = 0
│   │           #            var abilities: Array[String] = [], var image_url: String
│   │           #            var is_exerted: bool = false, var current_zone: GameManager.Zone
│   │           # Node refs: @onready var card_image: TextureRect = $CardImage
│   │           #           @onready var card_name_label: Label = $CardName
│   │           #           @onready var strength_label: Label = $StatsContainer/StrengthLabel
│   │           # Methods: setup_from_data(card_data_dict), update_visual_for_type()
│   │           #         load_image_from_url(), highlight(), select(), exert(), ready()
│   │           #         can_be_played(available_ink), get_play_cost()
│   │           #         apply_damage(amount), is_banished(), has_ability(ability_name)
│   │           # Signals: signal clicked(card), signal drag_started(card), signal played(card)
│   │           # Handles: all card types through conditional logic, visual states, interaction
│   │           # Type logic: CHARACTER shows stats, ACTION shows effects, ITEM shows ongoing, SONG shows shift
│   │
│   ├── zones/                      
│   │   # TEMPLATE SCENES - instantiated as children in player_area.tscn
│   │   # Each zone extends ZoneBase with specific functionality
│   │   │
│   │   ├── hand_zone.tscn          
│   │   │   # Root: HandZone (Control) with HBoxContainer layout
│   │   │   # Purpose: horizontal card arrangement with selection
│   │   │   # Children:
│   │   │   #   ├── CardContainer (HBoxContainer) - holds card instances
│   │   │   #   └── HandInfo (VBoxContainer) - hand size and controls
│   │   │   #       ├── HandCounter (Label) - "Hand: 5/7"
│   │   │   #       └── HandActions (HBoxContainer) - hand-specific buttons
│   │   │   # Layout: cards spread horizontally with spacing, counter below
│   │   │   # Behavior: automatic card arrangement, selection highlighting
│   │   │   └── hand_zone.gd        
│   │   │       # ATTACHED to hand_zone.tscn
│   │   │       # extends ZoneBase
│   │   │       # Properties: var selected_card: Card = null, var max_hand_size: int = 7
│   │   │       #            var card_spacing: float = 10.0
│   │   │       # Container: @onready var card_container: HBoxContainer = $CardContainer
│   │   │       # Counter:   @onready var hand_counter: Label = $HandInfo/HandCounter
│   │   │       # Methods: arrange_cards(), select_card(card), deselect_all()
│   │   │       #         can_add_card() -> bool, get_selected_card() -> Card
│   │   │       #         highlight_playable_cards(available_ink)
│   │   │       # Signals: signal card_selected(card), signal hand_size_changed(size)
│   │   │       # Override: add_card() with arrangement, remove_card() with cleanup
│   │   │
│   │   ├── play_zone.tscn          
│   │   │   # Root: PlayZone (Control) with custom layout
│   │   │   # Purpose: character positioning and combat targeting
│   │   │   # Children:
│   │   │   #   ├── CharacterGrid (GridContainer) - 2x3 grid for character placement
│   │   │   #   ├── TargetingOverlay (Control) - visual targeting effects
│   │   │   #   └── ZoneInfo (VBoxContainer) - character count and status
│   │   │   #       └── CharacterCount (Label) - "Characters: 4/6"
│   │   │   # Layout: grid positioning with targeting visuals
│   │   │   # Behavior: drag-drop placement, combat target selection
│   │   │   └── play_zone.gd        
│   │   │       # ATTACHED to play_zone.tscn
│   │   │       # extends ZoneBase
│   │   │       # Properties: var max_characters: int = 6, var selected_attacker: Card = null
│   │   │       # Grid ref: @onready var character_grid: GridContainer = $CharacterGrid
│   │   │       # Overlay:  @onready var targeting_overlay: Control = $TargetingOverlay
│   │   │       # Methods: place_character(card, grid_position), get_character_at_position(pos)
│   │   │       #         get_valid_challenge_targets() -> Array[Card]
│   │   │       #         highlight_targets(targets), clear_targeting_highlights()
│   │   │       #         exert_character(card), ready_all_characters()
│   │   │       # Signals: signal character_placed(card, position), signal target_selected(target)
│   │   │       #         signal challenge_initiated(attacker, target)
│   │   │       # Override: add_card() with grid placement, remove_card() with position cleanup
│   │   │
│   │   ├── deck_zone.tscn          
│   │   │   # Root: DeckZone (Control) with VBoxContainer layout
│   │   │   # Purpose: deck pile management and drawing
│   │   │   # Children:
│   │   │   #   ├── DeckPile (Control) - visual representation of deck
│   │   │   #   │   ├── DeckBackground (ColorRect) - pile background
│   │   │   #   │   └── TopCard (TextureRect) - shows deck back or empty
│   │   │   #   └── DeckInfo (VBoxContainer) - deck status
│   │   │   #       ├── DeckCounter (Label) - "Deck: 45"
│   │   │   #       └── DrawButton (Button) - "Draw" (if needed)
│   │   │   # Layout: pile visual with counter, draw interaction
│   │   │   # Behavior: deck shuffling, card drawing, empty deck handling
│   │   │   └── deck_zone.gd        
│   │   │       # ATTACHED to deck_zone.tscn
│   │   │       # extends ZoneBase  
│   │   │       # Properties: var deck_cards: Array[Card] = [], var is_shuffled: bool = false
│   │   │       # Pile refs: @onready var deck_background: ColorRect = $DeckPile/DeckBackground
│   │   │       #           @onready var deck_counter: Label = $DeckInfo/DeckCounter
│   │   │       # Methods: shuffle_deck(), draw_card() -> Card, peek_top_card() -> Card
│   │   │       #         is_empty() -> bool, get_deck_count() -> int
│   │   │       #         load_deck_from_list(card_ids), update_visual()
│   │   │       # Signals: signal card_drawn(card), signal deck_empty(), signal deck_shuffled()
│   │   │       # Override: add_card() to bottom, remove_card() from top (draw)
│   │   │
│   │   └── discard_zone.tscn       
│   │       # Root: DiscardZone (Control) with VBoxContainer layout
│   │       # Purpose: discard pile management and viewing
│   │       # Children:
│   │       #   ├── DiscardPile (Control) - visual pile representation
│   │       #   │   ├── PileBackground (ColorRect) - pile background
│   │       #   │   └── TopCard (TextureRect) - shows top discarded card
│   │       #   └── DiscardInfo (VBoxContainer) - pile status and controls
│   │       #       ├── DiscardCounter (Label) - "Discard: 8"
│   │       #       └── ViewButton (Button) - "View Pile"
│   │       # Layout: pile visual with top card shown, view interaction
│   │       # Behavior: shows recent discards, pile viewing, graveyard effects
│   │       └── discard_zone.gd     
│   │           # ATTACHED to discard_zone.tscn
│   │           # extends ZoneBase
│   │           # Properties: var discard_cards: Array[Card] = [], var viewing_pile: bool = false
│   │           # Pile refs: @onready var top_card_display: TextureRect = $DiscardPile/TopCard
│   │           #           @onready var discard_counter: Label = $DiscardInfo/DiscardCounter
│   │           #           @onready var view_button: Button = $DiscardInfo/ViewButton
│   │           # Methods: add_to_discard(card), get_top_card() -> Card
│   │           #         view_discard_pile(), close_pile_view()
│   │           #         get_discard_count() -> int, update_top_card_display()
│   │           # Signals: signal card_discarded(card), signal pile_viewed(), signal pile_closed()
│   │           # Override: add_card() to top of pile, remove_card() with pile updates
│   │
│   ├── ui/
│   │   └── deck_builder.tscn       
│   │       # Root: DeckBuilder (Control) with HSplitContainer layout
│   │       # Purpose: deck construction and validation interface
│   │       # Children:
│   │       #   ├── LeftPanel (Control) - card browser and filters
│   │       #   │   ├── FilterControls (VBoxContainer)
│   │       #   │   │   ├── SearchBox (LineEdit) - "Search cards..."
│   │       #   │   │   ├── TypeFilter (OptionButton) - "All Types/Character/Action/etc"
│   │       #   │   │   └── CostFilter (SpinBox) - cost range selection
│   │       #   │   └── CardList (ItemList) - available cards display
│   │       #   ├── RightPanel (Control) - current deck and validation
│   │       #   │   ├── DeckInfo (VBoxContainer) - deck statistics
│   │       #   │   │   ├── DeckName (LineEdit) - "My Deck"
│   │       #   │   │   ├── DeckStats (Label) - "60/60 cards, 2 colors"
│   │       #   │   │   └── ValidationStatus (Label) - "Deck Valid" / errors
│   │       #   │   ├── DeckList (ItemList) - current deck contents
│   │       #   │   └── DeckActions (HBoxContainer)
│   │       #   │       ├── SaveDeck (Button) - "Save Deck"
│   │       #   │       ├── LoadDeck (Button) - "Load Deck"
│   │       #   │       └── ClearDeck (Button) - "Clear All"
│   │       #   └── BottomPanel (Control) - navigation and testing
│   │       #       ├── BackToMenu (Button) - "Back to Menu"
│   │       #       └── TestDeck (Button) - "Play vs AI"
│   │       # Layout: card browser left, deck building right, controls bottom
│   │       # Behavior: real-time validation, drag-add cards, deck management
│   │       └── deck_builder.gd     
│   │           # ATTACHED to deck_builder.tscn
│   │           # class_name DeckBuilder extends Control
│   │           # Properties: var current_deck: Array[String] = [] (card IDs)
│   │           #            var deck_name: String = "New Deck"
│   │           #            var filtered_cards: Array[Dictionary] = []
│   │           # UI refs: @onready var card_list: ItemList = $LeftPanel/CardList
│   │           #         @onready var deck_list: ItemList = $RightPanel/DeckList
│   │           #         @onready var deck_stats: Label = $RightPanel/DeckInfo/DeckStats
│   │           #         @onready var validation_status: Label = $RightPanel/DeckInfo/ValidationStatus
│   │           # Methods: add_card_to_deck(card_id), remove_card_from_deck(card_id)
│   │           #         validate_deck() -> bool, update_deck_display()
│   │           #         filter_cards(search_text, type_filter, cost_filter)
│   │           #         save_deck_to_file(), load_deck_from_file()
│   │           # Validation: check_deck_size() (60 cards), check_card_limits() (max 4)
│   │           #           check_ink_colors() (max 2), display_validation_errors()
│   │           # Signals: signal deck_saved(name), signal deck_loaded(name), signal deck_valid_changed(valid)
│   │           # Handles: complete deck building workflow, real-time validation feedback
│   │
│   └── ai/
│       └── ai_player.tscn          
│           # Root: AIPlayer (Node) - AI controller component
│           # Purpose: automated player decisions and actions
│           # Children:
│           #   ├── DecisionTimer (Timer) - natural pacing for AI actions
│           #   ├── BehaviorController (Node) - AI personality and strategy
│           #   └── DebugOutput (Control) - AI decision visualization (optional)
│           # Behavior: extends Player with automated decision making
│           └── ai_player.gd        
│               # ATTACHED to ai_player.tscn
│               # class_name AIPlayer extends Player
│               # Properties: var ai_behavior: AIBehavior, var difficulty_level: int = 1
│               #            var decision_delay: float = 1.5, var thinking_time: float = 0.0
│               # Timer ref: @onready var decision_timer: Timer = $DecisionTimer
│               # Behavior: @onready var behavior_controller: Node = $BehaviorController
│               # Methods: make_turn_decisions(), choose_card_to_play() -> Card
│               #         select_combat_target(attacker) -> Card, decide_quest_or_challenge(card)
│               #         evaluate_hand() -> Array[Card], assess_board_state() -> Dictionary
│               # Override: all Player methods with AI logic, natural timing delays
│               # Strategy: mana curve following, threat assessment, lore racing
│               # Signals: signal decision_made(action, target), signal ai_turn_complete()
│               # Connects: to game events, responds with delayed appropriate actions
│
├── src/                            
│   # AUTOLOAD SCRIPTS - configured in Project Settings → Autoload
│   # All globally accessible throughout the game, persistent across scenes
│   │
│   ├── game_manager.gd             
│   │   # AUTOLOAD NAME: GameManager
│   │   # class_name GameManager extends Node
│   │   # Purpose: global game state, constants, and utility functions
│   │   # Constants: const MAX_HAND_SIZE: int = 7, const WIN_LORE: int = 20
│   │   #           const MAX_DECK_SIZE: int = 60, const STARTING_HAND_SIZE: int = 7
│   │   # Enums: enum CardType {CHARACTER, ACTION, ITEM, SONG}
│   │   #       enum Zone {HAND, PLAY, DECK, DISCARD, INKWELL}  
│   │   #       enum GamePhase {READY, DRAW, PLAY}
│   │   #       enum InkColor {AMBER, AMETHYST, EMERALD, RUBY, SAPPHIRE, STEEL}
│   │   # State: var current_player: Player = null, var current_phase: GamePhase
│   │   #       var turn_count: int = 0, var game_in_progress: bool = false
│   │   # Methods: check_win_condition(player) -> bool, end_game(winner)
│   │   #         get_opposing_player(player) -> Player, is_valid_target(card, target) -> bool
│   │   # Signals: signal game_started(), signal game_ended(winner), signal turn_changed(player)
│   │   # Access: GameManager.WIN_LORE, GameManager.CardType.CHARACTER, etc.
│   │
│   ├── card_database.gd            
│   │   # AUTOLOAD NAME: CardDatabase  
│   │   # class_name CardDatabase extends Node
│   │   # Purpose: card data loading, storage, and retrieval
│   │   # Properties: var cards: Dictionary = {} (card_id -> card_data_dict)
│   │   #            var sets: Dictionary = {} (set_name -> Array[card_ids])
│   │   #            var abilities: Dictionary = {} (ability_name -> effect_data)
│   │   # Methods: load_cards_from_json(), get_card_data(card_id) -> Dictionary
│   │   #         get_all_cards() -> Array[Dictionary], get_cards_by_type(type) -> Array
│   │   #         create_card_instance(card_id) -> Card, search_cards(query) -> Array
│   │   #         get_cards_in_set(set_name) -> Array[Dictionary]
│   │   # Data structure: {"id": "001", "name": "Mickey Mouse", "type": "Character", 
│   │   #                "cost": 3, "strength": 2, "willpower": 3, "lore_value": 2,
│   │   #                "abilities": ["Rush"], "image_url": "https://...", 
│   │   #                "flavor_text": "...", "ink_color": "Amber"}
│   │   # Access: CardDatabase.get_card_data("001"), CardDatabase.create_card_instance("001")
│   │
│   └── deck_manager.gd             
│       # AUTOLOAD NAME: DeckManager
│       # class_name DeckManager extends Node  
│       # Purpose: deck operations, validation, and storage
│       # Properties: var starter_decks: Dictionary = {}, var saved_decks: Dictionary = {}
│       #            var deck_save_path: String = "user://saved_decks/"
│       # Methods: create_deck_from_ids(card_ids) -> Array[Card], shuffle_deck(cards)
│       #         validate_deck(deck) -> Dictionary (valid: bool, errors: Array[String])
│       #         save_deck(name, card_ids), load_deck(name) -> Array[String]
│       #         get_starter_deck(name) -> Array[String], get_all_deck_names() -> Array[String]
│       # Validation: check_deck_size(), check_card_limits(), check_ink_requirements()
│       #           check_format_legality(), generate_validation_report()
│       # Storage: handles file I/O for deck persistence, auto-saves recent decks
│       # Access: DeckManager.validate_deck(my_deck), DeckManager.save_deck("My Deck", card_ids)
│
├── scripts/
│   # UTILITY CLASSES AND BASE CLASSES - not autoloaded, instantiated as needed
│   │
│   ├── base/
│   │   ├── zone_base.gd            
│   │   │   # class_name ZoneBase extends Control
│   │   │   # Purpose: foundation for all game zones (hand, play, deck, discard)
│   │   │   # Properties: @export var zone_type: GameManager.Zone
│   │   │   #            var owned_cards: Array[Card] = []
│   │   │   #            var max_capacity: int = -1 (unlimited if -1)
│   │   │   # Methods: add_card(card: Card) -> bool, remove_card(card: Card) -> bool
│   │   │   #         get_cards() -> Array[Card], get_card_count() -> int
│   │   │   #         can_accept_card(card: Card) -> bool, clear_zone()
│   │   │   #         find_card(card_id: String) -> Card, has_card(card: Card) -> bool
│   │   │   # Signals: signal card_added(card: Card), signal card_removed(card: Card)
│   │   │   #         signal zone_clicked(), signal zone_capacity_changed()
│   │   │   # Virtual: _on_card_added(), _on_card_removed() (override in subclasses)
│   │   │   # Usage: extended by HandZone, PlayZone, DeckZone, DiscardZone
│   │   │
│   │   └── player.gd               
│   │       # class_name Player extends Node
│   │       # Purpose: base player functionality and state management
│   │       # Properties: var player_name: String = "Player", var lore: int = 0
│   │       #            var available_ink: int = 0, var max_ink: int = 0
│   │       #            var player_area: PlayerArea = null
│   │       #            var is_ai: bool = false, var is_active: bool = false
│   │       # Methods: draw_card() -> Card, play_card(card: Card) -> bool
│   │       #         gain_lore(amount: int), gain_ink(amount: int = 1)
│   │       #         can_play_card(card: Card) -> bool, get_playable_cards() -> Array[Card]
│   │       #         ready_all_characters(), exert_character(card: Card)
│   │       #         take_turn(), end_turn()
│   │       # Signals: signal lore_changed(new_lore), signal ink_changed(new_ink)
│   │       #         signal card_played(card), signal turn_ended()
│   │       # Virtual: make_decisions() (overridden by AIPlayer for automation)
│   │
