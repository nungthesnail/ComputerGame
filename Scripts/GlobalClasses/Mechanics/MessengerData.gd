extends Resource

var chats : Dictionary = {}


func new_chat(username, avatar):
	chats[username] = {
		"username": username,
		"avatar": avatar,
		"messages": [],
		"unread": false
	}
	return chats[username]


func get_chat(id):
	return chats.get(id)


func get_chats():
	return chats


func get_chat_by_username(username : String):
	for chat in chats.values():
		if chat["username"] == username:
			return chat
	
	return null


func send_message(username, data, new_avatar=0):
	var chat = get_chat_by_username(username)
	if !chat:
		chat = new_chat(username, new_avatar)
	
	if data is Array:
		chat["messages"].append_array(data)
	else:
		chat["messages"].append(data)
	chat["unread"] = true


func notificate():
	Dialoging.play_dialog("res://Game/Dialogs/SystemDialogs.dialogue", "blobtalk_notification", false, "blobtalk_notification")


func prepare_save() -> Dictionary:
	var dict : Dictionary = {
		"blobtalk": chats
	}
	
	# print("\n\n--- MessengerData prepared for saving: {0}".format([dict]))
	return dict


func reset():
	chats = {}


func load_from_dict(dict : Dictionary):
	reset()
	
	var blobtalk : Dictionary = dict.get("blobtalk", {})
	var ids = blobtalk.keys()
	var data = blobtalk.values()
	
	for i in range(ids.size()):
		if ("username" in data[i].keys()
			&& "avatar" in data[i].keys()
			&& "messages" in data[i].keys()
			&& "unread" in data[i].keys()):
			chats[ids[i]] = data[i]
		else:
			push_error("Failed to load corrupted blobtalk chat {0}".format([data[i]]))
