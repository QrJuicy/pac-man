extends CanvasLayer

@onready var score_label = $ScoreLabel 

var score: int = 0  

# Function to update the score
func update_score(amount: int):
	score += amount  
	score_label.text = "Score: " + str(score)  
