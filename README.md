# Memoria de Desarrollo: Videojuego de Lucha 2D. Dragon Ball Close Combat.

### Hecho por:
- Anas Oulghazi
- Alejandro Rodríguez
- Ángel Del Río


## 1. Conceptualización



## 2. Arte

En la parte visual se ha diseñado un juego estilo 2d con pixel art inspirado en juegos como Streat Figther, pero adaptado con personajes, fondos, escenario, interfaz grafica y sprites de la icónica seria de *Dragon Ball* 

### A. Sprites de Personajes

En los sprites los dos personajes hasta el momento (Cooler y Goku) estos cuentan con las mismas animaciones, a continuación solo se utilizará a un personaje para mostrar como se mueven.

- **Idle:** Animación de reposo y guardia.

	![Idle](img_Readme/cooler_Idle.gif)

- **Entrada:** Animación de entrada al combate.
	
	![Entrada](img_Readme/entrada.gif)

- **Ataque:** Animación de puñetazo.

	![Puñetazo](img_Readme/puño.gif)

- **Movimiento:** Animación de movimiento.

	![Movimiento](img_Readme/movimiento.gif)

- **Recibir golpe:** Animación de retroceso después de recibir golpe.
	  
	![Recibir](img_Readme/recibir.png)

- **Muerte:** Animación de muerte.
  
	![muerte](img_Readme/muerte.gif)

### B. Interfaz de Usuario

La interfaz no es solo visual, sino que forma parte de la experiencia funcional del juego:
- **Barra de Salud:** La barra de salud es del estilo artístico de *Dragon Ball* ya que son rastreadores que muestran el estado de vida actual del jugador.
	
	![Barra de VIda](img_Readme/barraVida.gif)

- **Iconos:** Los iconos muestran a quien pertenece cada barra de vida y aparecen encima de las mismas.
   
   ![Icono](img_Readme/cooler_assets.png)
   ![Icono2](img_Readme/goku_assets.png)

- **Vida Extra:** La esfera es una bola del dragón que al cogerla se convierte en una vida para el jugador que primero consiga alcanzarla.

	![esfera](img_Readme/esfera.png)

- **Menú:** Al iniciar el juego se muestra el menú con las diferentes opciones.

	![Menu](img_Readme/Menu.png)

- **Pantalla de controles:** Se muestra los controles de cada jugador y para que sirve la bola de dragón.

	![controles](img_Readme/controles.png)


- **Escenario de combate:** Es donde ocurre toda la acción, cuenta con diferentes plataformas y obtáculos que dan dinamismo al combate.

	![escenario](img_Readme/escenario.png)

- **Knockout:** Se trata de un sprite que aparece cuando un jugador muere, por la fuente que sea.

	![K.O](img_Readme/Knockout.png)

### C. Sonidos

En el juego se han implementado varios sonidos para que la inmersión del juego se más realista y fiel a la serie.

- **Sonido del menú:** En el menú se escucha una de la muchas icónicas melodías con las que cuenta **Dragon Ball**.
- **Sonido de pelea:** Se escucha de fondo una música de tensión, digna de la saga de **Dragon Ball Z**.
- **Sonido de golpeo:** Cuando los personajes dan un puñetazo se escucha un sonido de golpeo el cual refuerza la sensación de impacto y realismo de la batalla.
-  **Sonido de K.O:** Cuando uno de los personaje muere y concluye la batalla se escucha un sondo diciendo "K.O".

## 3. Programación

En este apartado se detallan los elementos técnicos utilizados para el desarrollo del videojuego, explicando su funcionamiento de forma estructurada y clara.

El juego ha sido desarrollado utilizando el motor **Godot Engine**, haciendo uso de nodos como `CharacterBody2D`, `Area2D`, `AnimationPlayer` y el sistema de señales para la comunicación entre elementos.


### A. Pantallas

La gestión de pantallas (menú, controles, combate, etc.) se ha implementado mediante el uso de escenas independientes.

Para cambiar entre pantallas se utiliza el método:

- `get_tree().change_scene_to_file()` para cargar nuevas escenas.
- `get_tree().current_scene` para acceder a la escena activa.
- `create_timer()` para realizar transiciones temporizadas, como al finalizar el combate.

Los botones del menú están conectados mediante señales, permitiendo ejecutar funciones específicas al ser pulsados.


### B. Personajes

Los personajes están programados mediante scripts que heredan de `CharacterBody2D`, lo que permite aprovechar el sistema de físicas integrado del motor.

Ambos personajes comparten prácticamente la misma estructura lógica para garantizar equilibrio en el combate.

La programación del personaje se divide en distintos sistemas:


#### B.1 Sistema de Movimiento

El movimiento horizontal se gestiona mediante:

- `Input.get_axis()` para detectar dirección.
- `move_toward()` para aplicar aceleración y fricción progresiva.
- `move_and_slide()` para aplicar el movimiento final respetando colisiones.

El salto se controla verificando si el personaje está en el suelo con `is_on_floor()` antes de aplicar la fuerza vertical.

La gravedad se aplica manualmente mediante una función que incrementa la velocidad vertical cuando el personaje no está apoyado en el suelo.


#### B.2 Sistema de Animaciones

Las animaciones están controladas mediante un `AnimationPlayer`.

Se utilizan señales como:

- `animation_finished`
- `frame_changed`

Esto permite:

- Activar la hitbox de ataque en el frame exacto del golpe.
- Reproducir sonidos sincronizados con el impacto.
- Detectar cuándo termina una animación para cambiar de estado.

La función `update_animation()` decide qué animación reproducir dependiendo del estado actual del personaje (idle, movimiento, salto, ataque, recibir golpe o muerte).


#### B.3 Sistema de Combate

El combate se basa en un sistema de detección por **hitboxes**.

Cada personaje cuenta con:

- **Hitbox corporal:** Esta hitbox está siempre activa por defecto y es la que permite que el jugador pueda apoyarse en el suelo e interactuar con los elementos del mapa, como plataformas, enemigos, collecionables y el otro jugador, por supuesto.
- **Hitbox de ataque (Area2D):** Esta hitbox funciona de una forma algo más compleja a la corporal. Por defecto, esta hitbox está siempre desactivada y solo se hace sólida cuando el jugador realiza un ataque

Cuando la hitbox de ataque detecta un cuerpo enemigo mediante la señal `body_entered`, se llama a la función `recibir_golpe()` del rival.

Dentro de esa función:

- Se aplica retroceso modificando la `velocity`.
- Se reduce la vida mediante `quitar_vida()`.
- Se activa un estado de stun temporal.
- Se activa un estado de invencibilidad breve.

Esto evita que un jugador pueda recibir múltiples impactos consecutivos sin posibilidad de reacción.


#### B.4 Sistema de Estados

El personaje funciona mediante un sistema de estados booleanos:

- `atacando`
- `estuneado`
- `invencible`
- `muerto`
- `entrando`

En cada `physics_process` se verifica el estado actual y se ejecuta el comportamiento correspondiente.

Este sistema permite:

- Bloquear movimiento durante ataques, es decir, si un jugador inicia la acción de ataque este no podrá realizar ninguna otra acción, a excepción de un pequeño pivotaje en el aire, mientras la animación del golpe esté activa.
- Impedir acciones mientras está stuneado.
- Ignorar daño mientras es invencible.
- Desactivar colisiones al morir.

La función `handle_invencible()` controla el tiempo de invulnerabilidad reduciendo un temporizador cada frame.


#### B.5 Sistema de Vida

Cada personaje tiene:

- `vida_maxima`
- `vida_actual`

Cuando recibe daño:

1. Se reduce la vida con `clamp()` para evitar valores negativos.
2. Se emite la señal `actualizar_interfaz_vida`.
3. Si la vida llega a 0 se ejecuta `morir()`.

Al morir:

- Se desactivan capas de colisión.
- Se reproduce la animación de muerte.
- Se muestra el sprite de K.O.
- Se regresa al menú tras un pequeño retardo.

Este sistema mantiene sincronizada la lógica del personaje con la interfaz gráfica.


#### B.6 Sistema de Vida Extra

Se implementó un objeto coleccionable (Bola de Dragón) que aparece tras un tiempo determinado.

Cuando un jugador entra en contacto con ella:

- Se comprueba que su vida no esté al máximo.
- Se suma 1 punto de vida.
- Se actualiza la interfaz automáticamente.

Con este objeto en combate se busca brindar mas dinamismo a la pelea y conseguir que los combates puedan cambiar su curso repentinamente haciéndolo más interesante.


## 4 . Elementos Destacables

En esta parte se detallan las mecánicas novedosas que aportan profundidad al gameplay y los problemas tenidos durante el desarrollo del proyecto de *Dragon Ball Close Combat*:
	
### A. Innovaciones

- **Sprite de vida vinculado a jugador:** La barra de vida está conectada directamente a los sprites, esto hace que cambie en tiempo real el estado de la vida del jugador, mostrando el color de la barra distinto según la cantidad de vida exacta que tenga el jugador en ese momento.
- **Sistema de Regeneración de vida:** Se implementó un sistema donde una Bola de Dragón aparece en el escenario tras un tiempo determinado. Si el jugador la recoge y no ha alcanzado su nivel máximo de salud (7 vidas) se suma un punto de vida automáticamente, actualizando de esta forma su barra de vida.
- **Mecánicas de Combate:**
	- **Impacto:** Al dar un puñetazo se activa la hitbox destinada a detectar dicho movimiento, si un cuerpo enemigo entra en contacto con esta hitbox mientras está activa ocurre el impacto deseado.
	- **Retroceso:** Al recibir un ataque el personaje realiza automáticamente una animación de retroceso, simulando que ha recibido un golpe, durante la cual el personaje queda stuneado durante 0.5 segundos.
	- **Estado de Invencibilidad:** Tras recibir un golpe se activa un breve periodo de invulnerabilidad para evitar que el jugador pierda toda la vida por ataques seguidos, permitiendo una oportunidad de contraataque, ya que si no estuviese esta función un jugador podría acorralar a otro sin posibilidad de escape.

- **Knockout:** Se programó una detección de muerte que al terminar el combate hace aparecer un *sprite* de **K.O** en pantalla con un audio acorde a la epicidad del combate. Segundos después de la aparición del **K.O** en pantalla se regresará automaticamente al menú de inicio para iniciar una nueva partida.

### B. Problemas encontrados
  
