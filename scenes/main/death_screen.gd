extends Node2D

const DEATH_TEXTS = [
	"YOU FAILED YOUR MISSION",
	"YOU FAILED. MAYBE THEY SHOULDN'T HAVE SEND YOU",
	"YOU DIED DOING YOUR DUTY",
	"YOU'RE DEAD. MAY YOU REST IN PEACE"
]

func tween_btn(obj, scale=Vector2(1, 1)):
	var t = get_tree().create_tween().bind_node(self)
	t.tween_property(obj, "scale", scale, randf_range(0.1, 0.3)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

# Called when the node enters the scene tree for the first time.
func _ready():
	$LabelSpell.reset_text(DEATH_TEXTS.pick_random())
	$Retry.pressed.connect(retry)
	$Retry.selected.connect($Quit.unselect)
	$Retry.selected.connect(tween_btn.bind($Retry, Vector2(1.25, 1.25)))
	$Retry.unselected.connect(tween_btn.bind($Retry))
	
	$Quit.pressed.connect(quit)
	$Quit.selected.connect($Retry.unselect)
	$Quit.selected.connect(tween_btn.bind($Quit, Vector2(1.25, 1.25)))
	$Quit.unselected.connect(tween_btn.bind($Quit))

func retry():
	get_parent().load_level()

func quit():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("shoot"):
		$LabelSpell.skip()
	
	
	if event.is_action_pressed("ui_left"):
		$Retry.select()
	elif event.is_action_pressed("ui_right"):
		$Quit.select()


func _on_label_spell_finished():
	$Retry.visible = true
	$Quit.visible = true
