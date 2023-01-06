extends KinematicBody2D

const PlayerHurtSound = preload("res://Action RPG Resources/Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 85
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO   #.ZERO means origin point, think resting position of analog stick
var roll_vector = Vector2.DOWN
var stats = PlayerStats #Created via autoload singleton in project settings

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $HurtBox #This is the only thing that differs from tutorial, supposed to be $Hurtbox but don't want to have to change every instance
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	randomize() #IMPORTANT!!! THIS MAKES THE GAME'S SEED RANDOMIZE SO THE SAME EVENTS DON'T HAPPEN OVER AND OVER AGAIN, IF TESTING, REMOVE THIS!!!
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _process(delta):      #_physics_process = frame rate synced to physics, can be just _process to help with performance
	match state:           #State Machine - Sets what actions are avaliable
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state(delta)
		
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()           #Important when setting move state so diagonals aren't faster
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector                     #ONLY WHEN VECTOR ISN'T .ZERO
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):          #Behavior of "action button"
		state = ATTACK

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):                               #This determines attack mode characteristics
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)                 #GD script command for movement, linking to velocity

func roll_animation_finished():
	velocity = velocity * 0.3
	state = MOVE

func attack_animation_finished():                       #When attack animation finishes, revert back to "Move" state
	state = MOVE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6) #Determines invincibility duration
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_HurtBox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_HurtBox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
