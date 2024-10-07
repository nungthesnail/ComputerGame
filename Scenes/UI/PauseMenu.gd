extends Control


func resume_game():
	get_tree().paused = false
	ObjectRefs.ui_root.delete_cover("pause_menu")


func main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")


func tab_selected(idx : int):
	match idx:
		0:
			resume_game()
		1:
			$VBoxContainer/ContentContainer/Game.visible = true
			$VBoxContainer/ContentContainer/Map.visible = false
			$VBoxContainer/ContentContainer/Inventory.visible = false
		2:
			$VBoxContainer/ContentContainer/Game.visible = false
			$VBoxContainer/ContentContainer/Map.visible = true
			$VBoxContainer/ContentContainer/Inventory.visible = false
		3:
			$VBoxContainer/ContentContainer/Game.visible = false
			$VBoxContainer/ContentContainer/Map.visible = false
			$VBoxContainer/ContentContainer/Inventory.visible = true
