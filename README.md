# Memoria de Desarrollo: Videojuego de Lucha 2D

### Hecho por:
- Anas Oulghazi
- Alejandro Rodríguez
- Ángel Del Río


## 1. Conceptualización

## 2. Arte

En la parte visual se ha diseñado un juego estilo 2d estilo Streat Figther, pero adaptado con personajes, fondos, escenario, interfaz grafica y sprites de *Dragon Ball* 

### A. Sprites de Personajes

En los sprites los dos personajes(Cooler y Goku) tienen las mismas animaciones solo se utilizara a un personaje para mostrar como se mueven.


- **Idle:** Animación de reposo y guardia típica de los guerreros Z

    ![Idle](img_Readme/cooler_Idle.gif)

- **Entrada:** Animación de entrada al combate
    
    ![Entrada](img_Readme/entrada.gif)

- **Ataque:** Animación de puñetazo

    ![Puñetazo](img_Readme/puño.gif)

- **Movimiento:** Animación de movimiento

    ![Movimiento](img_Readme/movimiento.gif)

- **Recibir golpe:** Animación de retroceso después de recibir golpe
      
    ![Recibir](img_Readme/recibir.png)

- **Muerte:** Animación de muerte
  
    ![muerte](img_Readme/muerte.gif)

### B. Interfaz de Usuario
La interfaz no es solo funcional, sino que forma parte de la experiencia visual del juego:
- **Barra de Salud:** La barra de salud es del estilo artístico de *Dragon Ball* ya que son rastreadores que muestran el estado de vida actual del jugador.
    
    ![Barra de VIda](img_Readme/barraVida.gif)

- **Iconos:** Los iconos muestran a quien pertenece la barra de vida ya que están encima de la barra de vida de cada jugador
   
   ![Icono](img_Readme/cooler_assets.png)
   ![Icono2](img_Readme/goku_assets.png)

- **Vida Extra:** La esfera es una bola del dragón que al cogerla se convierte en una vida para el jugador

    ![esfera](img_Readme/esfera.png)

- **Menú:** Al iniciar el juego se muestra el menú con las diferentes opciones

    ![Menu](img_Readme/Menu.png)

- **Pantalla de controles:** Se muestra los controles de cada jugador y para que sirve la bola de dragón

    ![controles](img_Readme/controles.png)


- **Escenario de combate:** Es donde ocurre toda la acción

    ![escenario](img_Readme/escenario.png)

- **Knockout:** Un sprite que aparece cuando un jugador muere

    ![K.O](img_Readme/Knockout.png)

### C. Sonidos

En el juego se han implementado varios sonido para que la inmersión del juego se más realista y fiel a la serie **Dragon Ball**

- **Sonido del menú:** En el menú se escucha la música de introducción de la serie
- **Sonido de pelea:** Se escucha de fondo una música de tensión de la saga de dragon ball z
- **Sonido de golpeo:** Cuando los personajes dan un puñetazo se escucha un sonido de golpeo para que de una Sención de fuerza y realismo al la batalla
-  **Sonido de K.O:** Cuando uno de los personaje muere y concluye la batalla se escucha un sondo diciendo "K.O"
  

## 3. Programación

## 4. Elementos Destacables (Innovaciones y Problemas)

En esta parte se detallan las mecánicas novedosas que aportan profundidad al gameplay y los problemas tenidos durante el desarrollo del proyecto de *Dragon Ball*:

- **Sistema de Regeneración de vida:** Se implementó un sistema donde una Bola de Dragón aparece en el escenario tras un tiempo determinado. Si el jugador la recoge y no ha alcanzado su nivel máximo de salud (7 vidas)se suma una vida automáticamente
- **Sprite de vida vinculado a jugador:** La barra de vida está conectada directamente a los sprites, esto hace cambie en tiempo real el estado de la vida del jugador, mostrando color de la barra distinto según la cantidad de vida exacta que tenga el jugador en ese momento
- **Mecánicas de Combate:**
    - **Impacto y Sonido:** Al dar un puñetazo se activa un efecto de sonido de golpeo para dar realismo y sensación de fuerza
    - **Retroceso:** Al recibir un ataque el personaje realiza automáticamente una animación de retroceso, simulando que ha recibido un golpe
    - **Estado de Invencibilidad:** Tras recibir un golpe se activa un breve periodo de invulnerabilidad para evitar que el jugador pierda toda la vida por ataques seguidos permitiendo una oportunidad de contraataque ya que si no estuviese esta función un jugador podría acorralar a otro sin posibilidad de escape

- **Knockout:** Se programó una detección de muerte que al terminar el combate hace aparecer un *sprite* de **K.O** en pantalla con un audio para acabar con la batalla segundos después volver a la pantalla de inicio
  
