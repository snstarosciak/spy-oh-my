extends "res://Doors/Door.gd"

onready var Numpad = $CanvasLayer/Numpad

func _ready():
    $Label.rect_rotation = -rotation_degrees
    
func _on_Door_input_event(viewport, event, shape_idx):
    if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_click:
        Numpad.popup_centered()
        
func _on_Door_body_exited(body):
    if body.collision_layer == 1:
        can_click = false
        Numpad.hide()

func _on_Numpad_combination_correct():
    # Comes from Door.gd
    can_click = false
    open()
    Numpad.hide()

    
func door_closed():
    can_click = true


func _on_Computer_combination(numbers, lock_group):
    $Label.text = lock_group
    $CanvasLayer/Numpad.combination = numbers
