extends Node


class TestData:
	var input_values : Array[String] = []
	var result
	var counter : int = 0
	var passed : bool = false
	
	func _init(_input_values : Array[String], _result):
		input_values = _input_values
		result = _result


class Interpreter:
	var lua : LuaAPI = LuaAPI.new()
	var input_data : Array = []
	var input_data_tests : Array[TestData] = []
	var tests_counter : int = 0
	var code : String = "" 
	var print_callback : Callable = func (data) : pass
	
	func _init(_code : String, _input_data : String = "", _print_callback : Callable = func (data) : pass):
		code = _code
		input_data = _input_data.split("\n")
		print_callback = _print_callback
	
	func init():
		lua.bind_libraries(["base", "table", "string"])
		lua.push_variant("print", print_callback)
		lua.push_variant("input", get_input)
	
	func push_test_data(data : Array[TestData]):
		input_data_tests = data
	
	func get_input():
		if input_data_tests.is_empty():
			if input_data.is_empty():
				return null
			return input_data.pop_front()
		else:
			var test = input_data_tests[tests_counter]
			if test.counter >= test.input_values.size():
				return null
			test.counter += 1
			return test.input_values[test.counter - 1]
	
	func execute():
		var err : LuaError = lua.do_string(code)
		if err:
			print_callback.call("[color=red]Ошибка: {0}[/color]\n".format([err.message]))
		if !lua.function_exists("main"):
			print_callback.call("[color=red]Ошибка: функции \"main\" не существует[/color]\n")
		
		var ret = lua.call_function("main", [])
		if input_data_tests && tests_counter < input_data_tests.size():
			var test = input_data_tests[tests_counter]
			if "{0}".format([ret]) == "{0}".format([test.result]):
				test.passed = true
			tests_counter += 1
		
		return ret


var interpreter : Interpreter = null


func create_interpreter(_code : String = "", _input_data : String = "", _print_callback : Callable = func (data) : pass):
	interpreter = Interpreter.new(_code, _input_data, _print_callback)
	interpreter.init()
	update_tests()
	
	return interpreter


func update_tests():
	if Tasking.current_task:
		if Tasking.current_task.has_method("get_lua_tests"):
			interpreter.push_test_data(Tasking.current_task.get_lua_tests())


func execute():
	if !interpreter:
		return
	
	update_tests()
	var ret
	if !interpreter.input_data_tests.is_empty():
		for i in range(interpreter.input_data_tests.size()):
			ret = interpreter.execute()
		Tasking.update_task(Tasking.TaskUpdate.TYPE_LUA_EXECUTED, {
			"tests_passed": is_tests_passed(),
			"return": ret
		})
	else:
		ret = interpreter.execute()
		Tasking.update_task(Tasking.TaskUpdate.TYPE_LUA_EXECUTED, {
			"tests_passed": is_tests_passed(),
			"return": ret
		})
	
	return ret


func is_tests_passed():
	if !interpreter:
		return false
	
	var tests = interpreter.input_data_tests
	for t in tests:
		if t.passed == false:
			return false
	return true
