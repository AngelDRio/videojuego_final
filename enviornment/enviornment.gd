extends Node2D

var vida_extr_escena = preload("res://bonus/VidaExtra.tscn")
@onready var temporizdor = $Timer
@onready var interfaz = $CapaInterfaz
@onready var knockout = $CanvasLayer/Knockout

func mostrar_knockout():
	knockout.show()   # Mostramos cuando alguien muera
	get_tree().paused = true

func _ready() -> void:
	if interfaz == null: return
	if knockout:
		knockout.hide()


	if has_node("Player1"):
		var p1 = $Player1
		p1.actualizar_interfaz_vida.connect(interfaz.actualizar_barra_p1)
		interfaz.actualizar_barra_p1(p1.vida_actual)
	
	if has_node("Player2"):
		var p2 = $Player2
		p2.actualizar_interfaz_vida.connect(interfaz.actualizar_barra_p2)
		interfaz.actualizar_barra_p2(p2.vida_actual)
		
	temporizdor.timeout.connect(aparecer_bola)

func aparecer_bola():
	if get_tree().get_nodes_in_group("bolas_vida").size() < 1:
		var nueva_bola = vida_extr_escena.instantiate()
		nueva_bola.add_to_group("bolas_vida")
		var x_aleatoria = randf_range(334, 816) 
		nueva_bola.position = Vector2(x_aleatoria, 349)
		add_child(nueva_bola)
