extends Control

signal upgrade_confirmed
signal speed_upgraded
signal slide_upgraded
signal carrying_upgraded

enum UpgradeType {
	NONE,
	SPEED,
	SLIDE,
	CARRYING
}

var selected_upgrade: UpgradeType

@onready var confirm_button = $PanelContainer/VBoxContainer/ConfirmButton


func _on_confirm_button_pressed():
	if selected_upgrade == UpgradeType.NONE:
		return
	
	match (selected_upgrade):
		UpgradeType.SPEED:
			speed_upgraded.emit()
		UpgradeType.SLIDE:
			slide_upgraded.emit()
		UpgradeType.CARRYING:
			carrying_upgraded.emit()
	
	selected_upgrade = UpgradeType.NONE
	upgrade_confirmed.emit()
	confirm_button.disabled = true


func _on_speed_upgrade_button_pressed():
	selected_upgrade = UpgradeType.SPEED
	confirm_button.disabled = false


func _on_slide_upgrade_button_pressed():
	selected_upgrade = UpgradeType.SLIDE
	confirm_button.disabled = false


func _on_carrying_upgrade_button_pressed():
	selected_upgrade = UpgradeType.CARRYING
	confirm_button.disabled = false
