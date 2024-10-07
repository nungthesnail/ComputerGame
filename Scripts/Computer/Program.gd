extends Resource
class_name Program


@export var back_processing : bool = false
@export var program_name : String = ""

var output_callback : Callable
var computer : Computer = null
var waiting_input : bool = false


func main(args : Array = []):
	pass

func continue_program(data : String = ""):
	pass

func accept_input(data : String = ""):
	pass

func process(delta : float): 
	pass

func end():
	if computer:
		computer.dispose_program(self)

func api(data : String):
	pass
