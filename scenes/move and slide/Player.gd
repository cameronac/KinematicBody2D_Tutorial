extends KinematicBody2D

#-----------Properties---------------
export var move_spd: float = 200;
var velocity: Vector2 = Vector2.ZERO;


#----------Methods-------------------
func _physics_process(_delta):
	var direction: Vector2 = check_input();
	velocity = Vector2.ZERO;
	velocity = move_and_slide(direction * move_spd, Vector2.ZERO, false, 4, 0, true);


func check_input():
	var direction = Vector2.ZERO;
	
	if (Input.is_action_pressed("ui_up")):
		direction.y -= 1;
	
	if (Input.is_action_pressed("ui_down")):
		direction.y += 1;
	
	if (Input.is_action_pressed("ui_right")):
		direction.x += 1;
	
	if (Input.is_action_pressed("ui_left")):
		direction.x -= 1;
	
	
	if (direction.x != 0 and direction.y != 0):
		var sign_of_x = sign(direction.x);
		var sign_of_y = sign(direction.y);
		direction.x = (sqrt(2) / 2) * sign_of_x;
		direction.y = (sqrt(2) / 2) * sign_of_y;
	
	return direction;
