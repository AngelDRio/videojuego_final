extends Node2D

var vida_extr_escena =preload("res://bonus/VidaExtra.tscn")

@onready var temporizdor = $Timer

func _ready() -> void:
	if has_node("Player1"):
		$Player1.actualizar_interfaz_vida.connect(_on_vida_p1_cambiada)
	if has_node("Player2"):
		$Player2.actualizar_interfaz_vida.connect(_on_vida_p1_cambiada)
	temporizdor.timeout.connect(aparecer_bola)

func aparecer_bola():
	if get_tree().get_nodes_in_group("bolas_vida").size() < 1:
		var nueva_bola = vida_extr_escena.instantiate()
		
		nueva_bola.add_to_group("bolas_vida")
		
		var x_aleatoria = randf_range(334, 816) # Un poco de margen por los lados
		nueva_bola.position = Vector2(x_aleatoria, 349)
		
		add_child(nueva_bola)

func _on_vida_p1_cambiada(puntos):
	var barra = get_node_or_null("CapaInterfaz/BarraVidaP1")
	if barra != null:
		barra.frame = puntos

func _process(delta: float) -> void:
	pass
