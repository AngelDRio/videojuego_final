extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var speed = 100
var sentido = 1

func _ready() -> void:
	$ani_ene.play("movimiento")

func _on_ene_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador1") || body.is_in_group("jugador2"):
		if body.has_method("recibir_golpe"):
			body.recibir_golpe(1, global_position)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	if is_on_wall():
		sentido = -sentido
		
	if sentido == 1 && $detectorIzquierdo.is_colliding():
		velocity.x = speed
		$ani_ene.flip_h = false
	elif sentido == -1 && $detectorDerecho.is_colliding():
		velocity.x = -speed
		$ani_ene.flip_h = true
	else:
		sentido = -sentido # Cambia de dirección si no hay suelo

	move_and_slide()
