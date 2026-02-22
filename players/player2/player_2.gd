extends CharacterBody2D

@export var gravity_scale = 2
@export var speed = 500
@export var acceleration = 600
@export var friction = 1500
@export var jump_force = -700
@export var air_acceleration = 2000
@export var air_friction = 150

signal actualizar_interfaz_vida(puntos)
var vida_maxima = 7
var vida_actual = 7
var muerto = false

@onready var sonido_punetazo = $Punetazo
@onready var ani_player = $ani_player2
@onready var hitbox = $hitbox_player2

var atacando = false
var estuneado = false
var invencible = false

@export var tiempo_stun = 0.5
@export var tiempo_invencible = 1.0
var stun_timer = 0.0
var invencible_timer = 0.0

var hitbox_offset_x
var mirando_izquierda = false

var entrando = true

func _ready():
	add_to_group("jugador2")
	hitbox.monitoring = false
	
	if not hitbox.body_entered.is_connected(_on_hitbox_player_2_body_entered):
		hitbox.body_entered.connect(_on_hitbox_player_2_body_entered)
	
	ani_player.frame_changed.connect(_on_frame_changed)
	hitbox_offset_x = hitbox.position.x
	
	ani_player.animation_finished.connect(_on_animation_finished)
	ani_player.play("entrada")
func _physics_process(delta):
	if entrando: 
		move_and_slide()
		return

	if muerto:
		apply_gravity(delta)
		move_and_slide()
		return
	
	handle_invencible(delta)
	
	if estuneado:
		stun_timer -= delta
		apply_gravity(delta)
		move_and_slide()
		ani_player.play("recibir")
		if stun_timer <= 0:
			estuneado = false
		return

	var input_axis = Input.get_axis("goku_izquierda", "goku_derecha")

	if Input.is_action_just_pressed("goku_punetazo") and not atacando:
		atacando = true
		if is_on_floor():
			velocity.x = 0
		ani_player.play("punetazo")

	apply_gravity(delta)

	if not atacando:
		handle_acceleration(input_axis, delta)
		apply_friction(input_axis, delta)
		handle_jump()
		handle_air_acceleration(input_axis, delta)
		update_animation(input_axis)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, friction * delta)
		else:
			handle_air_acceleration(input_axis, delta)

	move_and_slide()

func update_animation(input_axis):
	if muerto: return
	
	if input_axis != 0:
		mirando_izquierda = input_axis < 0
		ani_player.flip_h = mirando_izquierda
		hitbox.position.x = -abs(hitbox_offset_x) if mirando_izquierda else abs(hitbox_offset_x)

	if atacando: return

	if not is_on_floor():
		ani_player.play("salto")
	elif input_axis != 0:
		ani_player.play("movimiento")
	else:
		ani_player.play("idle")

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed * input_axis, acceleration * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handle_jump():
	if is_on_floor() and Input.is_action_just_pressed("goku_salto"):
		velocity.y = jump_force

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_scale

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed * input_axis, air_acceleration * delta)

func _on_frame_changed():
	if ani_player.animation == "punetazo":
		hitbox.monitoring = true
		
		if ani_player.frame == 2: 
			sonido_punetazo.play()
			
		if ani_player.frame == ani_player.sprite_frames.get_frame_count("punetazo") - 1:
			atacando = false
			hitbox.monitoring = false

func recibir_golpe(danio, posicion_enemigo):
	if muerto or invencible:
		return
		
	var direccion = 1 if global_position.x > posicion_enemigo.x else -1
	velocity = Vector2(direccion * 200, -150)
	
	quitar_vida(danio)
	
	if not muerto:
		estuneado = true
		stun_timer = tiempo_stun
		invencible = true
		invencible_timer = tiempo_invencible
		atacando = false
		ani_player.play("recibir")

func quitar_vida(danio: int):
	if muerto: return
	
	vida_actual = clamp(vida_actual - danio, 0, vida_maxima)
	actualizar_interfaz_vida.emit(vida_actual)
	
	if vida_actual <= 0:
		morir()

func morir():
	if muerto: 
		return
	muerto = true

	atacando = false
	estuneado = true
	invencible = true

	# Desactivar colisiones
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	hitbox.set_deferred("monitoring", false)

	# Mostrar KO en la escena principal (Environment)
	get_tree().current_scene.mostrar_knockout()

	if ani_player.sprite_frames.has_animation("muerte"):
		ani_player.play("muerte")

		# Esperar a que termine la animación de muerte
		await ani_player.animation_finished

		# Esperar 4 segundos antes de eliminar el jugador
		var timer = get_tree().create_timer(4.0, true)  # true = ignora pausa
		await timer.timeout

		if is_inside_tree():
			queue_free()
	else:
		# Si no hay animación de muerte, esperar 4 segundos y luego eliminar
		var timer = get_tree().create_timer(4.0, true)
		await timer.timeout
		if is_inside_tree():
			queue_free()

func handle_invencible(delta):
	if invencible:
		invencible_timer -= delta
		modulate.a = 0.5
		if invencible_timer <= 0:
			invencible = false
			modulate.a = 1.0

func _on_hitbox_player_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador1") and body.has_method("recibir_golpe"):
		body.recibir_golpe(1, global_position)
		
func _on_animation_finished():
	if ani_player.animation == "entrada":
		entrando = false
		ani_player.play("idle")
	if ani_player.animation == "punetazo":
		atacando = false
		hitbox.monitoring = false
