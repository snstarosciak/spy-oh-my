extends MarginContainer

# Player will be centered at the center of the map
# so we need a link to the player, since all mobs are relative to it
export (NodePath) var player
export var zoom = 1.5 setget set_zoom # setup a get/set function for this particular variable

onready var Grid = $MarginContainer/Grid
onready var PlayerMarker = $MarginContainer/Grid/PlayerMarker
onready var MobMarker = $MarginContainer/Grid/MobMarker
onready var AlertMarker = $MarginContainer/Grid/AlertMarker

# We need a way to map the icon tags to the actual character
onready var icons = { "guard": MobMarker }

# Scale factor to go from the size of the world to the size of the map
var grid_scale

# Keep a list of markers. e.g. there are 10 mobs and each one will have a marker assigned to each one
# So we're gonna keep a dictionary to store the objects to the markers
var markers = {}

func _ready():
    PlayerMarker.position = Grid.rect_size / 2
    grid_scale = Grid.rect_size / (get_viewport_rect().size * zoom)
    
    # Find all the objects in the group (This could be problematic if you have multiple levels).
    # If need to grab for just the level, could grab all nodes in scene and check if they are of type "Guard"
    var guard_objects = get_tree().get_nodes_in_group("minimap_objects")
    for item in guard_objects:
        var new_marker = icons[item.minimap_icon].duplicate()
        Grid.add_child(new_marker)
        new_marker.show()
        markers[item] = new_marker
    
func _process(delta):
    if !player:
        return
        
    # Rotate the character appropriately
    PlayerMarker.rotation = get_node(player).rotation
    
    # Put the markers on the map
    for item in markers:
        
        # Get the marker's position in the world and subtract it from the player's position
        var obj_pos = (item.position - get_node(player).position) * grid_scale + Grid.rect_size / 2
        
        # Check to see if the marker is within the bounding box of the Grid inside the margins of the container.
        # If so, scale them to their normal size
        if Grid.get_rect().has_point(obj_pos + Grid.rect_position):
            markers[item].scale = Vector2(1, 1)
        else:
            # Otherwise, show them smaller to indicate they are further off the screen
            markers[item].scale = Vector2(.5, .5)
            
        #Constrain position to be inside the bounding map box
        obj_pos.x = clamp(obj_pos.x, 0, Grid.rect_size.x)
        obj_pos.y = clamp(obj_pos.y, 0, Grid.rect_size.y)
        
        # Make sure the marker in our dictionary has the position of the marker in the world
        markers[item].position = obj_pos

func set_zoom(value):
    zoom = clamp(value, 0.5, 5)
    grid_scale = Grid.rect_size / (get_viewport_rect().size * zoom)


# When zooming with mousewheel inside the minimap, adjust the distance between elements
func _on_MiniMap_gui_input(event):
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == BUTTON_WHEEL_UP:
            self.zoom += 0.1
        if event.button_index == BUTTON_WHEEL_DOWN:
            self.zoom -= 0.1
