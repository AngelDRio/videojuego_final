extends CharacterBody2D

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
@onready var ani_player = $ani_player2
@onready var hitbox = $hitbox_player2

# ESTADO
var atacando = false

func _ready():
	hitbox.monitoring = false
	ani_player.frame_changed.connect(_on_frame_changed)

func _physics_process(delta):
	var input_axis = Input.get_axis("goku_izquierda", "goku_derecha")

	# ATAQUE
	if Input.is_action_just_pressed("goku_punetazo") and not atacando:
		atacando = true

		# detener solo en el suelo al iniciar el ataque
		if is_on_floor():
			velocity.x = 0

		ani_player.play("punetazo")

	# GRAVEDAD SIEMPRE
	apply_gravity(delta)

	# Si aterrizas mientras atacas, frena la velocidad horizontal
	if atacando and is_on_floor():
		velocity.x = 0

	# MOVIMIENTO
	if not atacando:
		handle_acceleration(input_axis, delta)
		apply_friction(input_axis, delta)
		handle_jump()
		handle_air_acceleration(input_axis, delta)
		update_animation(input_axis)
	else:
		# permitir movimiento en el aire durante ataque
		if not is_on_floor():
			handle_air_acceleration(input_axis, delta)

	move_and_slide()

# ANIMACIONES
func update_animation(input_axis):
	if atacando:
		return

	if input_axis != 0:
		ani_player.flip_h = input_axis < 0
		ani_player.play("movimiento")
	elif not is_on_floor():
		ani_player.play("salto")
	else:
		ani_player.play("idle")

# MOVIMIENTO SUELO
func handle_acceleration(input_axis, delta):
	if not is_on_floor():
		return

	if input_axis != 0:
		# Detectar si cambiamos de dirección
		if sign(velocity.x) != sign(input_axis) and velocity.x != 0:
			# Frenar más rápido al cambiar de dirección
			velocity.x = move_toward(velocity.x, 0, friction * delta)

		# Luego acelerar hacia la nueva dirección
		velocity.x = move_toward(
			velocity.x,
			speed * input_axis,
			acceleration * delta
		)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(
			velocity.x,
			0,
			friction * delta
		)

# SALTO
func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("goku_salto"):
			velocity.y = jump_force

# GRAVEDAD
func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_scale

# MOVIMIENTO AIRE
func handle_air_acceleration(input_axis, delta):
	if is_on_floor():
		return

	if input_axis != 0:
		velocity.x = move_toward(
			velocity.x,
			speed * input_axis,
			air_acceleration * delta
		)

# HITBOX Y FIN ATAQUE
func _on_frame_changed():
	if ani_player.animation == "punetazo":
		# activar solo en frame del impacto
		if ani_player.frame == 2: # CAMBIA ESTE NUMERO
			hitbox.monitoring = true
		else:
			hitbox.monitoring = false

		# detectar fin animación
		if ani_player.frame == ani_player.sprite_frames.get_frame_count("punetazo") - 1:
			atacando = false
			hitbox.monitoring = false

			# volver a animación correcta
			if not is_on_floor():
				ani_player.play("salto")
			else:
				ani_player.play("idle")

# VIDA
func quitar_vida(cantidad):
	vida_actual = clamp(
		vida_actual - cantidad,
		0,
		vida_maxima
	)
	actualizar_interfaz_vida.emit(vida_actual)
