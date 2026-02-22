extends CharacterBody2D

# ====== CONFIGURACIÓN ======
@export var gravity_scale = 2
@export var speed = 500
@export var acceleration = 600
@export var friction = 1500
@export var jump_force = -700
@export var air_acceleration = 2000
@export var air_friction = 150

# VIDA
signal actualizar_interfaz_vida(puntos)
var vida_maxima = 7
var vida_actual = 7

# NODOS
@onready var ani_player = $ani_player1
@onready var hitbox = $hitbox_player1

# ESTADOS
var atacando = false
var estuneado = false
var invencible = false

# TIMERS
@export var tiempo_stun = 0.5
@export var tiempo_invencible = 1.0
var stun_timer = 0.0
var invencible_timer = 0.0

# HITBOX
var hitbox_offset_x
var mirando_izquierda = false

func _ready():
	add_to_group("jugador1")
	hitbox.monitoring = false
	# Esto asegura que la señal se conecte sí o sí al arrancar
	if not hitbox.body_entered.is_connected(_on_hitbox_player_1_body_entered):
		hitbox.body_entered.connect(_on_hitbox_player_1_body_entered)
	ani_player.frame_changed.connect(_on_frame_changed)
	hitbox_offset_x = hitbox.position.x
	
	if has_node("Player1"):
		$Player1.actualizar_interfaz_vida.connect(_on_vida_p1_cambiada)
	if has_node("Player2"):
		$Player2.actualizar_interfaz_vida.connect(_on_vida_p2_cambiada)


func _physics_process(delta):
	handle_invencible(delta)
	
	# ====== LÓGICA DE STUN (BLOQUEA INPUTS) ======
	if estuneado:
		stun_timer -= delta
		apply_gravity(delta)
		move_and_slide()
		ani_player.play("recibir")
		
		if stun_timer <= 0:
			estuneado = false
		return # No permite procesar nada más si está estuneado

	var input_axis = Input.get_axis("cooler_izquierda", "cooler_derecha")

	# ATAQUE
	if Input.is_action_just_pressed("cooler_punetazo") and not atacando:
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

# ====== ANIMACIONES ======
func update_animation(input_axis):
	if input_axis != 0:
		mirando_izquierda = input_axis < 0
		ani_player.flip_h = mirando_izquierda
		hitbox.position.x = -abs(hitbox_offset_x) if mirando_izquierda else abs(hitbox_offset_x)

	if atacando: 
		return

	if not is_on_floor():
		ani_player.play("salto")
	elif input_axis != 0:
		ani_player.play("movimiento")
	else:
		ani_player.play("idle")

# ====== MOVIMIENTO ======
func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed * input_axis, acceleration * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handle_jump():
	if is_on_floor() and Input.is_action_just_pressed("cooler_salto"):
		velocity.y = jump_force

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_scale

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed * input_axis, air_acceleration * delta)

# ====== HITBOX (ATAQUE) ======
func _on_frame_changed():
	if ani_player.animation == "punetazo":
		hitbox.monitoring = true

		if ani_player.frame == ani_player.sprite_frames.get_frame_count("punetazo") - 1:
			atacando = false
			hitbox.monitoring = false

# ====== RECIBIR DAÑO ======
func recibir_golpe(danio, posicion_enemigo):
	if invencible: return
	quitar_vida(danio)
	actualizar_interfaz_vida.emit(vida_actual)
	
	estuneado = true
	stun_timer = tiempo_stun
	invencible = true
	invencible_timer = tiempo_invencible
	atacando = false # Cancela su ataque si le pegan
	
	ani_player.play("recibir")

	# Knockback
	var direccion = 1 if global_position.x > posicion_enemigo.x else -1
	velocity = Vector2(direccion * 200, -150)

func handle_invencible(delta):
	if invencible:
		invencible_timer -= delta
		modulate.a = 0.5 # Efecto visual de invencibilidad
		if invencible_timer <= 0:
			invencible = false
			modulate.a = 1.0


func _on_hitbox_player_1_body_entered(body: Node2D) -> void:
	print("¡ALGO HA ENTRADO EN LA HITBOX!") # <--- Añade esto
	if body.is_in_group("jugador2"):
		print("ES EL JUGADOR 2") # <--- Añade esto
		if body.has_method("recibir_golpe"):
			body.recibir_golpe(1, global_position)

#Controlar la vida
func _on_vida_p1_cambiada(puntos):
	var barra = get_node_or_null("CapaInterfaz/BarraVidaP1")
	if barra != null:
		barra.frame = puntos  # Cambia el frame según la vida actual

func _on_vida_p2_cambiada(puntos):
	var barra = get_node_or_null("CapaInterfaz/BarraVidaP2")
	if barra != null:
		barra.frame = puntos

func quitar_vida(danio: int):
	vida_actual = clamp(vida_actual - danio, 0, vida_maxima)
	actualizar_interfaz_vida.emit(vida_actual)
	print("Vida actual:", vida_actual) 
	if vida_actual <= 0:
		print("Player va a morir")
		morir()

func morir():
	atacando = false
	estuneado = true
	velocity = Vector2.ZERO
	hitbox.monitoring = false
	queue_free()
