extends Node


var TaskClass = load("res://Scripts/GlobalClasses/Tasking.gd").Task


class TestMission extends Tasking.Task:
	var count : int = 0
	
	func start(data=null):
		print("Task is starting!")
		super.start(data)
	
	func update(upd : Tasking.TaskUpdate, data=null):
		if upd.type == upd.TYPE_ITEM_COLLECTED && is_instance_valid(data):
			if data.is_in_group("TestMission"):
				count += 1
				print("Item collected! Lets continue...")
		
		super.update(upd, data)
	
	func process(data=null):
		if count >= 5:
			end()
		
		super.process(data)
	
	func end(data=null):
		print("It is so cooooool! You\'ve just completed the mission!")
		super.end(data)
