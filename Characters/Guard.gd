extends "res://NPCs/PlayerDetection.gd"

# To make this as malleable as possible, we're going to look at the entire tree and just find all instances of "Navigation2D"
# - This is better than doing something like get_parent().get_parent() blah blah blah, locking us into this architecture
onready var navigation = get_tree().get_root().find_node("Navigation2D", true, false)
onready var destinations = navigation.get_node("Destinations")

var motion
var possible_destinations
var path
var minimap_icon = "guard"

export var minimum_arrival_distance = 5
export var walk_speed = 0.5

func _ready():
    
    # Seeds this script with a random number
    randomize()
    
    # Get all of the actual nodes from inside the "Destinations" Node, wherever it is in the tree. This leaves us with an array of possible destinations
    possible_destinations = destinations.get_children()    
    make_path()


# Create a new destination by choosing a random destination from all the possible ones
func make_path():
    var new_destination = possible_destinations[randi() % possible_destinations.size() - 1]
    path = navigation.get_simple_path(position, new_destination.position, false)
    
func _physics_process(delta):
    navigate()
    
func navigate():
    var distance_to_destination = position.distance_to(path[0])
    if distance_to_destination > minimum_arrival_distance:
        move()
    else:
        update_path() 
        
func move():
    # calls a function on node2d that just points the character to the "forward" point
    look_at(path[0])
    motion = (path[0] - position).normalized() * (MAX_SPEED * walk_speed)
    
    if(is_on_wall()):
        make_path()
        
    move_and_slide(motion)
    
func update_path():
    # If the path is 0, then there is no destination to go and the game will crash
    if path.size() == 1:
        if $Timer.is_stopped():
            $Timer.start()
    else:
        path.remove(0)
    

func _on_Timer_timeout():
    make_path()
