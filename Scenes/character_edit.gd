extends Control

@export var for_player = false
@export var target: CharacterBody2D

var display
var partlist

func _ready():
	$Sections/Name.placeholder_text = "(*) Relative's Name"

	if target:
		$Sections/Name.text = target.get_node("Name/Tag").text

	if for_player:
		partlist = Parts
		$Sections/Title.text = "Change your appearance to your liking"

		$Sections/Name.visible = false
		$Sections/Submit.visible = false
		$Sections/SubmitNote.visible = false

		display = preload("res://Entities/player.tscn").instantiate()
		display.ACTIVE = false
		$Sections/Panel/Control.add_child(display)
		display.get_node("AnimationPlayer").play("Walk")
		new_head(Settings.setting.player_parts.Head)
		new_body(Settings.setting.player_parts.Body)
		new_wand(Settings.setting.player_parts.Wand)
	else:
		partlist = Parts.Undead
		$Sections/Title.text = "Who is your relative?"

		$Sections/Done.disabled = true
		$Sections/Submit.disabled = true

		if !("not_submitted" in Settings.setting.relative):
			$Sections/Submit.visible = false
			$Sections/SubmitNote.visible = false

		display = preload("res://Entities/undead.tscn").instantiate()
		display.ACTIVE = false
		display.remove_from_group("undead")
		$Sections/Panel/Control.add_child(display)
		display.get_node("AnimationPlayer").play("Walk")
		new_head(0)
		new_body(0)
		new_wand(0)

	display.get_node("Collision").disabled = true

func new_head(idx):
	$Sections/Head/Selected.value = idx

	display.set_head(partlist.Head[idx])

	if target:
		target.set_head(partlist.Head[idx])

	if for_player:
		Settings.setting.player_parts.Head = idx
		Settings.update()

	if self.visible:
		Audio.play("Audio/Click.ogg")

func new_body(idx):
	$Sections/Body/Selected.value = idx

	display.set_body(partlist.Body[idx])

	if target:
		target.set_body(partlist.Body[idx])

	if for_player:
		Settings.setting.player_parts.Body = idx
		Settings.update()

	if self.visible:
		Audio.play("Audio/Click.ogg")

func new_wand(idx):
	$Sections/Wand/Selected.value = idx

	display.set_wand(partlist.Wand[idx])

	if target:
		target.set_wand(partlist.Wand[idx])

	if self.visible:
		Audio.play("Audio/Click.ogg")

	if for_player:
		Settings.setting.player_parts.Wand = idx
		Settings.update()

func _on_name_text_changed(new_text:String):
	if target:
		target.get_node("Name/Tag").text = new_text

	if new_text.length() >=3:
		$Sections/Done.disabled = false
		$Sections/Submit.disabled = false
	else:
		$Sections/Done.disabled = true
		$Sections/Submit.disabled = true

	if self.visible:
		Audio.play("Audio/Click.ogg")

	display.get_node("Name/Tag").text = new_text

func _on_done_pressed():
	self.visible = false

	Audio.play("Audio/Click.ogg")

	Settings.setting.relative_name = $Sections/Name.text
	Settings.update()

	if target:
		target.get_node("Name").visible = true

	if "on_charedit_close" in get_parent():
		get_parent().on_charedit_close()

func _on_http_request_request_completed(result:int, response_code:int, _headers:PackedStringArray, _body:PackedByteArray):
	if response_code == 200:
		Settings.update()
	else:
		Settings.setting.relative = Settings.default_setting.relative
		push_error("%d, %d" % [result, response_code])

func _on_submit_pressed():
	if not for_player and "not_submitted" in Settings.setting.relative:
		var send = JSON.stringify({
			"Name": $Sections/Name.text,
			"Head": $Sections/Head/Selected.value,
			"Body": $Sections/Body/Selected.value,
			"Wand": $Sections/Wand/Selected.value,
		})
		Settings.setting.relative = send

		$HTTPRequest.request("http://45.140.185.64:30006", ["Content-Type: application/json"], HTTPClient.METHOD_POST, send)

	_on_done_pressed()
