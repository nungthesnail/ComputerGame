extends Control


@onready var chat_preview_template = preload("res://Scripts/Computer/Programs/Messenger/ChatPreviewTemplate.tscn")
@onready var message_template = preload("res://Scripts/Computer/Programs/Messenger/MessageTemplate.tscn")
var chats_data : Dictionary = {}
var cache : Dictionary = {
	"textures": {}
}

@onready var chats_container = $MainContainer/SplitContainer/Chats/ChatsContainer/ChatsContainer2
@onready var messages_container = $MainContainer/SplitContainer/Messages/DataContainer/MessagesContainer/MessagesContainer2
@onready var data_container = $MainContainer/SplitContainer/Messages/DataContainer/UserDataContainer

var parent_process : Program = null


func _ready():
	chats_data = GameProgress.messenger_data.get_chats()
	cache_textures()
	create_previews()


func cache_textures():
	for chat in chats_data.values():
		if !ResourceLoader.exists(str(chat["avatar"])):
			cache["textures"][chat["username"]] = PlaceholderTexture2D.new() # Здесь будет нормальный аватар
			cache["textures"][chat["username"]].size = Vector2(64,64)
		else:
			cache["textures"][chat["username"]] = load(chat["avatar"])


func create_previews():
	for child in chats_container.get_children():
		child.queue_free()
	
	for chat in chats_data.values():
		var preview = chat_preview_template.instantiate()
		preview.set_avatar(cache["textures"].get(chat["username"], null))
		preview.set_username(chat["username"])
		preview.set_notification(chat["unread"])
		preview.click_callback = load_chat
		chats_container.add_child(preview)


func load_chat(username : String):
	for child in messages_container.get_children():
		child.queue_free()
	
	var chat = GameProgress.messenger_data.get_chat_by_username(username)
	if !chat:
		return
	
	data_container.get_node("UserName").text = chat["username"]
	data_container.get_node("AvatarContainer/Avatar").texture = cache["textures"].get(chat["username"])
	if chat["unread"]:
		chat["unread"] = false
		parent_process.api_data["last_read_chat"] = chat["username"]
	create_previews()
	
	for msg in chat["messages"]:
		var message : Control = message_template.instantiate()
		message.set_text(msg.trim_prefix("0").trim_prefix("1"))
		messages_container.add_child(message)
		if msg[0] == "0":
			message.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
		else:
			message.set_h_size_flags(Control.SIZE_SHRINK_END)
