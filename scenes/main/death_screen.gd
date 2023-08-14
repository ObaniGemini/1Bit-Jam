extends Node2D

const DEATH_TEXTS = [
	"YOU FAILED YOUR MISSION",
	"YOU FAILED. MAYBE THEY SHOULDN'T HAVE SEND YOU",
	"YOU DIED DOING YOUR DUTY",
	"YOU'RE DEAD. MAY YOU REST IN PEACE",
	"THE INSURANCE WON'T PAY"
]

var tweens = [null, null]

func tween_btn(idx, obj, vec=Vector2(1, 1)):
	if(tweens[idx] != null):
		tweens[idx].stop()
	
	var t = get_tree().create_tween().bind_node(self)
	t.tween_property(obj, "scale", vec, randf_range(0.1, 0.3)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tweens[idx] = t

# Called when the node enters the scene tree for the first time.
func _ready():
	$LabelSpell.reset_text(DEATH_TEXTS.pick_random())
	$Retry.pressed.connect(retry)
	$Retry.selected.connect(tween_btn.bind(0, $Retry, Vector2(1.25, 1.25)))
	$Retry.unselected.connect(tween_btn.bind(0, $Retry))
	
	$Quit.pressed.connect(quit)
	$Quit.selected.connect(tween_btn.bind(1, $Quit, Vector2(1.25, 1.25)))
	$Quit.unselected.connect(tween_btn.bind(1, $Quit))

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
