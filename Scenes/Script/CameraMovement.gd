extends Camera2D

@onready var player = $"../Player"
var cameraSpeed: float = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.get_axis("moveLeft", "moveRight") == 0:
		position = lerp(position, player.position + Vector2(0, -50), cameraSpeed*delta)
	elif Input.get_axis("moveLeft", "moveRight") < 0:
		position = lerp(position, player.position + Vector2(-100, 0), cameraSpeed*delta)
	else:
		position = lerp(position, player.position + Vector2(100, 0), cameraSpeed*delta)
