extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player1.actualizar_interfaz_vida.connect(_on_vida_cambiada)

func _on_vida_cambiada(puntos):
	$CapaInterfaz/BarraVidaP1.frame = puntos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
