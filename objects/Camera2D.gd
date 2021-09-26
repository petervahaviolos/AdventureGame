extends Camera2D

onready var top_left_limit = $Limits/TopLeft
onready var bottom_right_limit = $Limits/BottomRight


func _ready():
	limit_top = top_left_limit.position.y
	limit_left = top_left_limit.position.x
	limit_bottom = bottom_right_limit.position.y
	limit_right = bottom_right_limit.position.x
