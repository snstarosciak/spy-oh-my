extends Popup

onready var Label = $NinePatchRect/CenterContainer/NinePatchRect/Label

func set_text(combination):
    Label.text = "Will you stop foregetting your access code?! I've set it to " + PoolStringArray(combination).join("") + ", but this is the very last time, jackass."
    
