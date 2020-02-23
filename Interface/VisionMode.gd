extends CanvasModulate

const DARK = Color("131313")
const NIGHTVISION = Color("64e869")

# Note: might be cool to add an "alert" mode where the screen modulates
#        between red and black like "OH no!"
var cooldown = false

func _ready():
    color = DARK
    visible = true

func cycle_vision_mode():
    if not cooldown:
        if color == NIGHTVISION:
            toggle_lighting_mode('DARK')
        else:
            if $CooldownTimer.is_stopped():
                $CooldownTimer.start()
                toggle_lighting_mode('NIGHTVISION')
            cooldown = true
            $CooldownTimer.start()

func toggle_lighting_mode(mode):
    if mode == 'DARK':
        color = DARK
        $AudioStreamPlayer2D.stream = load("res://SFX/nightvision_off.wav")
        get_tree().call_group("lights", "show")
        get_tree().call_group("labels", "hide")
        $AudioStreamPlayer2D.play()
    elif mode == 'NIGHTVISION':
        color = NIGHTVISION
        get_tree().call_group("lights", "hide")
        get_tree().call_group("labels", "show")
        $AudioStreamPlayer2D.stream = load("res://SFX/nightvision.wav")
        $AudioStreamPlayer2D.play()
    

func _on_CooldownTimer_timeout():
    cooldown = false
