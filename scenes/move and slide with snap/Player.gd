 extends KinematicBody2D

#Nodes
onready var jump_timer = get_node("JumpTimer");

#Locks
export var smooth_movement = true;

#Movement Properties
export var walk_spd: int = 250;
export var jump_spd: int = 300;
export var gravity_spd: int = 20; # This spd will be incremented until terminal velocity is reached
export var terminal_velocity: int = 500; # Max amount of downward force
var velocity: Vector2; #Current Speed
var snap_vector: Vector2; #Used to Snap to Surfaces using the move_and_slide_with_snap method

#Smooth Movement Variables
export var air_control: float = 25;
export var horizontal_control = 15;
export var friction: float = 10;

#Input Variables
var horizontal_input: int;
var space: bool = false;

#Timer Values
export var jump_duration: float = 0.5;

#Movement Conditions
var on_floor: bool = false;

#------------------------Built-in Methods------------------------
func _physics_process(delta):
	update_input();
	movement_checks();
	update_actions(delta);
	reset_input();
#----------------------------------------------------------------

#------------------------Main Methods------------------------
#Update Input Variables
func update_input():
	if (Input.is_action_pressed("ui_right")):
		horizontal_input += 1;
	
	if (Input.is_action_pressed("ui_left")):
		horizontal_input -= 1;
	
	space = Input.is_action_pressed("ui_select");

func movement_checks():
	var kin_collision: KinematicCollision2D = move_and_collide(Vector2.DOWN, true, true, true);
	
	if (kin_collision != null):
		var normal: Vector2 = kin_collision.get_normal();
		
		if (normal == Vector2.UP):
			on_floor = true;
		else: 
			on_floor = false;
	else:
		on_floor = false;

#Checks input and applies the proper spds
func update_actions(delta: float):
	
	#Horizontal Movement
	horizontal_movement();
	
	#Vertical Movement
	if (on_floor and space):
		jump();
		on_floor = false;
	else: 
		apply_gravity();
	
	move();

func reset_input():
	horizontal_input = 0;
#-------------------------------------------------------------


#------------------------Movement Methods------------------------
func horizontal_movement():
	if (!smooth_movement):
		if (horizontal_input != 0):
			velocity.x = horizontal_input * walk_spd;
		else:
			velocity.x = 0;
	else:
		if (horizontal_input != 0 and on_floor):
			velocity.x = move_toward(velocity.x, horizontal_input * walk_spd, horizontal_control);
		elif(horizontal_input != 0 and !on_floor):
			velocity.x = move_toward(velocity.x, horizontal_input * walk_spd, air_control);
		elif (on_floor):
			velocity.x = move_toward(velocity.x, 0, friction);

#Add to velocity and increment it's downward spd
func apply_gravity():
	if (velocity.y < terminal_velocity):
		velocity.y += gravity_spd;

func jump():
	if (jump_timer.is_stopped()):
		jump_timer.start(jump_duration);
	velocity.y -= jump_spd;

#Move the player using the velocity variable
func move():
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, false, 4, PI*2, true);

#---------------------------------------------------------------


#------------------------Connections------------------------
func _on_JumpTimer_timeout():
	#velocity.y = 0;
	pass

