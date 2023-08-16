extends Node2D

const DEATH_TEXTS = [
	"YOU FAILED YOUR MISSION",
	"YOU FAILED. MAYBE THEY SHOULDN'T HAVE SEND YOU",
	"YOU DIED DOING YOUR DUTY",
	"YOU'RE DEAD. MAY YOU REST IN PEACE",
	"THE INSURANCE WON'T PAY",
	"YOU DIED...",
	"IT'S OK, IT'S JUST A GAME.",
	"DEATH IS THE ONLY UNKNOWN",
	"GAME OVER. CONTINUE?",
	"YOU DIDN'T SUFFER FROM THE EXPLOSION"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$LabelSpell.reset_text(DEATH_TEXTS.pick_random())
	$Retry.pressed.connect(retry)
	$Retry.default_tween()
	
	$Menu.pressed.connect(quit)
	$Menu.default_tween()

func retry():
	get_parent().load_level()

func quit():
	get_parent().go_to_menu()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$LabelSpell.skip()
	
	
	if event.is_action_pressed("ui_left"):
		$Menu.unselect()
		$Retry.select()
	elif event.is_action_pressed("ui_right"):
		$Retry.unselect()
		$Menu.select()


func _on_label_spell_finished():
	$Retry.visible = true
	$Menu.visible = true
