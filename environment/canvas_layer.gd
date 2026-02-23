extends CanvasLayer

@onready var barra_p1 = $BarraVida1 
@onready var barra_p2 = $BarraVida2 

func _ready():
	
	barra_p1.frame = 7
	barra_p2.frame = 7
	barra_p1.stop()
	barra_p2.stop()

func actualizar_barra_p1(puntos):
	if barra_p1:
		barra_p1.frame = puntos

func actualizar_barra_p2(puntos):
	if barra_p2:
		barra_p2.frame = puntos
