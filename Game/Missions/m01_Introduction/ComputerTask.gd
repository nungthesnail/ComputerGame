extends Program


func main(args : Array = []):
	waiting_input = false


func process(delta : float):
	if Tasking.current_task.step == 6:
		for p in computer.program_list:
			if p.program_name == "blobtalk":
				if p.api("last_read_chat") == "Миширану":
					Tasking.update_task(Tasking.TaskUpdate.TYPE_COMPUTER_EVENT, {"chat": "Миширану"})
	
	if Tasking.current_task.step == 7:
		for p in computer.program_list:
			if p.program_name == "netwalker":
				Tasking.update_task(Tasking.TaskUpdate.TYPE_COMPUTER_EVENT, {"program": "netwalker"})
	
	if Tasking.current_task.step == 8:
		for p in computer.program_list:
			if p.program_name == "netwalker":
				if p.api("last_response"):
					if p.api("last_response").contains("51.58913N, -0.17498W"):
						Tasking.update_task(Tasking.TaskUpdate.TYPE_COMPUTER_EVENT, {"response": "correct"})
	
	if Tasking.current_task.step == 9:
		for p in computer.program_list:
			if p.program_name == "blobtalk":
				if p.api("last_read_chat") == "Миширану":
					Tasking.update_task(Tasking.TaskUpdate.TYPE_COMPUTER_EVENT, {"chat": "Миширану"})
					end()
