extends Node2D

const DEATH_TEXTS = [
	"YOU FAILED YOUR MISSION",
	"YOU FAILED. MAYBE THEY SHOULDN'T HAVE SEND YOU",
	"YOU DIED DOING YOUR DUTY",
	"YOU'RE DEAD. MAY YOU REST IN PEACE",
	"THE INSURANCE WON'T PAY"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$LabelSpell.reset_text(DEATH_TEXTS.pick_random())
	$Retry.pressed.connect(retry)
	$Retry.default_tween()
	
	$Quit.pressed.connect(quit)
	$Quit.default_tween()

func retry():
	get_parent().load_level()

func quit():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$LabelSpell.skip()
	
	
	if event.is_action_pressed("ui_left"):
		$Quit.unselect()
		$Retry.select()
	elif event.is_action_pressed("ui_right"):
		$Retry.unselect()
		$Quit.select()


func _on_label_spell_finished():
	$Retry.visible = true
	$Quit.visible = true
