extends Node2D

var vida_extr_escena = preload("res://bonus/VidaExtra.tscn")
@onready var temporizdor = $Timer
@onready var interfaz = $CapaInterfaz
@onready var knockout = $KnockoutInterfaz/Knockout

func _ready() -> void:
	if interfaz == null: return
	if knockout:
		knockout.hide()
		knockout.scale = Vector2(0.1, 0.1)

	if has_node("Player1"):
		var p1 = $Player1
		p1.actualizar_interfaz_vida.connect(interfaz.actualizar_barra_p1)
		interfaz.actualizar_barra_p1(p1.vida_actual)
	
	if has_node("Player2"):
		var p2 = $Player2
		p2.actualizar_interfaz_vida.connect(interfaz.actualizar_barra_p2)
		interfaz.actualizar_barra_p2(p2.vida_actual)
		
	temporizdor.timeout.connect(aparecer_bola)

func mostrar_knockout():
	knockout.show()
	knockout.scale = Vector2(0.1, 0.1)
	
	# Tween para crecer
	var tween = create_tween()
	tween.tween_property(knockout, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var ko_sonido = $"KnockoutInterfaz/KO_Sound"
	if not ko_sonido.playing:
		ko_sonido.play()
		var timer = get_tree().create_timer(3.7, true)
		await timer.timeout
		get_tree().change_scene_to_file("res://UI/menu/menu.tscn")

func aparecer_bola():
	if get_tree().get_nodes_in_group("bolas_vida").size() < 1:
		var nueva_bola = vida_extr_escena.instantiate()
		nueva_bola.add_to_group("bolas_vida")
		var x_aleatoria = randf_range(334, 816) 
		nueva_bola.position = Vector2(x_aleatoria, 349)
		add_child(nueva_bola)
