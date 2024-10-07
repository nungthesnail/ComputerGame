extends Program


func get_program(pname : String) -> Program:
	for p in computer.program_list:
		if p.program_name == pname:
			return p
	return null


func main(data = null):
	waiting_input = false


func process(delta : float):
	if Tasking.current_task.step == 1:
		for p in computer.program_list:
			if p.program_name == "blobtalk":
				if p.api("last_read_chat") == "Миширану":
					Tasking.update_task(Tasking.TaskUpdate.TYPE_COMPUTER_EVENT, {"chat": "Миширану"})
	
	if Tasking.current_task.step == 2:
		for p in computer.program_list:
			if p.program_name == "luanvil":
				Tasking.update_task(Tasking.TaskUpdate.TYPE_COMPUTER_EVENT, {"program": "luanvil"})
	
	if Tasking.current_task.step == 4:
		for p in computer.program_list:
			if p.program_name == "blobtalk":
				if p.api("last_read_chat") == "Миширану":
					Tasking.update_task(Tasking.TaskUpdate.TYPE_COMPUTER_EVENT, {"chat": "Миширану"})
