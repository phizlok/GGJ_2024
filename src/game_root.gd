class_name GameRoot
extends Control

@onready var studio: Studio = $"%Studio"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_gradient(canvas_gradient: Image) -> void:
	studio.set_gradient(canvas_gradient)