extends "res://Characters/TemplateCharacter.gd"

const FOV_TOLERANCE = 20
const MAX_DETECTION_RANGE = 400
const RED = Color("#f08255")
const WHITE = Color("#FFFFFF")

var Player

func _ready():
    Player = get_node("/root").find_node("Player", true, false)
    
func _process(delta):
    if Player_in_FOV() and Player_in_LOS():
        $Torch.color = RED
        pass
    else:
        $Torch.color = WHITE
        
func Player_in_FOV():
    var npc_facing_direction = Vector2(1, 0).rotated(global_rotation)
    var direction_to_Player = (Player.position - global_position).normalized()
        
    # angle_to() works in radians and FOV_TOLERANCE is in degrees, so we need to convert it and then check
    # the player's direction in context of the npc's direction
    if abs(direction_to_Player.angle_to(npc_facing_direction)) < deg2rad(FOV_TOLERANCE):
        return true
    else:
        return false
        
func Player_in_LOS():
    var space = get_world_2d().direct_space_state
    var LOS_obstacle = space.intersect_ray(global_position, Player.global_position, [self], collision_mask)
    
    if not LOS_obstacle:
        return false
    
    var distance_to_player = Player.global_position.distance_to(global_position)
    var Player_in_Range = distance_to_player < MAX_DETECTION_RANGE
    
    if LOS_obstacle.collider == Player and Player_in_Range:
        return true
    else:
        return false