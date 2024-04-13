extends Control

signal upgrade_confirmed


func _on_confirm_button_pressed():
	upgrade_confirmed.emit()
