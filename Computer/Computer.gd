extends Node2D

var can_click = false
var combination
export var combination_length = 4
export var lock_group = "Unset"

signal combination

func _on_Area2D_body_entered(body):
    
    get_tree().call_group("player", "show_can_interact", true)
    # This would be a good spot to show some kind of indicator that it's clickable
    can_click = true

func _ready():
    generate_combination()
    $Label.rect_rotation = -rotation_degrees
    emit_signal("combination", combination, lock_group)
    $Label.text = lock_group
    
func generate_combination():
    combination = CombinationGenerator.generate_combination(combination_length)
    set_popup_text()

func set_popup_text():
    $CanvasLayer/ComputerPopup.set_text(combination)

func _on_Area2D_body_exited(body):
    can_click = false
    get_tree().call_group("player", "show_can_interact", false)
    $CanvasLayer/ComputerPopup.hide()
    $Light2D.enabled = false


func _on_Area2D_input_event(viewport, event, shape_idx):
    if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_click:
        $CanvasLayer/ComputerPopup.show()
        $Light2D.enabled = true

func seed_combination(generated_combination):
    print(generated_combination)
    combination = PoolStringArray(generated_combination).join("-")
    $CanvasLayer/ComputerPopup.seed_combination(combination)
