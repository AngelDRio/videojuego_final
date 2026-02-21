extends AnimatedSprite2D



func _ready():

	frame = 0

func actualizar_imagen_vida(puntos_vida):
	
	frame = puntos_vida
