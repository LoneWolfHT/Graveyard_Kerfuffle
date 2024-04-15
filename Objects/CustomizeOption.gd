extends HBoxContainer

enum CUSTOMIZE_PART {Name, Head, Body, Wand}

@export var PART: CUSTOMIZE_PART

func _on_selected_value_changed(value:float):
	if PART == CUSTOMIZE_PART.Head:
		owner.new_head(value)
	elif PART == CUSTOMIZE_PART.Body:
		owner.new_body(value)
	elif PART == CUSTOMIZE_PART.Wand:
		owner.new_wand(value)

func _on_setup_timeout():
	if PART == CUSTOMIZE_PART.Head:
		$Label.text = "Head"
		$Selected.max_value = owner.partlist.Head.size()-1
		$Selected.suffix = "/" + str(owner.partlist.Head.size()-1)
	elif PART == CUSTOMIZE_PART.Body:
		$Label.text = "Arms"
		$Selected.max_value = owner.partlist.Body.size()-1
		$Selected.suffix = "/" + str(owner.partlist.Body.size()-1)
	elif PART == CUSTOMIZE_PART.Wand:
		$Label.text = "Held Item"
		$Selected.max_value = owner.partlist.Wand.size()-1
		$Selected.suffix = "/" + str(owner.partlist.Wand.size()-1)
