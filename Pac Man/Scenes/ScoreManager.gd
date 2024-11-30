extends Node

var score = 0  # Start score at 0

@onready var score_ui = $"../ScoreUI/CanvasLayer/ScoreLabel"  # Path to your ScoreLabel in ScoreUI

# This function will be called when the coin is eaten or score needs to be updated
func update_score(amount: int):
	score += amount
	score_ui.text = str(score)  # Update the label text with the new score
	print("Score: ", score)  # For debugging, shows the score in the output console

# This function will reset the score to 0
func reset_score():
	score = 0
	score_ui.text = str(score)  # Reset the label text to show 0
	print("Score reset to 0")  # For debugging, shows the reset in the output console
