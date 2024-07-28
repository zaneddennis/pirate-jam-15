extends Panel
class_name ReadInterface


var texts: Array[String] = []
var ix = -1


func Activate(t: Array[String]):
	texts = t
	ix = -1
	
	TurnPage()
	show()


func Close():
	hide()


func TurnPage():
	ix += 1
	
	if ix < len(texts):
		$Text.text = texts[ix]
	
	else:
		Close()
		Link.player.input_mode = Link.player.INPUT_MODE.NORMAL
