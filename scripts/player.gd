extends Sprite

var speed = 200

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= speed * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += speed * delta
	
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += speed * delta
