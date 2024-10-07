extends Program


"""
commands:
	connect [ip/domain]
	add-packet [data]
	print-packets
	clear-packets
	send-request
	disconnect
"""
var ip_addresses = {
	"192.168.0.5": {
		"status": false,
		"callable": (func (data : Array = []):
			const pwd = "b2)w00Z*FX^yZ"
			var user_locations = {
				"nungthesnail": "48.85868N, 2.29410W",
				"zxc1234": "51.50811N, -0.12814W",
				"eddy75im": "51.58913N, -0.17498W"
			}
			var method = ""
			
			if data.size():
				data = data[0].duplicate()
				if data.size() < 2:
					return "ERROR 400: bad request"
				method = data[0]
				data = data.slice(1)
			else:
				return "ERROR 400: bad request"
			
			if method == "get" && data.size() >= 1:
				if data[0] == "user-location" && data.size() >= 2:
					if ip_addresses["192.168.0.5"]["status"]:
						return user_locations.get(data[1], null)
					else:
						return "ERROR 401: unauthorized"
				elif data[0] == "status":
					return "status:authorized" if ip_addresses["192.168.0.5"]["status"] else "status:unauthorized"
				elif data[0] == "login":
					return "Login dir"
				elif data[0] == "sitemap":
					return "user-location (get/post): returns coordinates of specified user\nstatus (get): returns status of this user\nlogin (post): authorization\nsitemap (get): map of the site"
				else:
					return "ERROR 404: no such route"
			elif method == "post" && data.size() >= 2:
				if data[0] == "user_location":
					return "ERROR 403: action forbidden" if ip_addresses["192.168.0.5"]["status"] else "ERROR 401: unauthorized"
				elif data[0] == "status":
					return "ERROR 405: method not allowed"
				elif data[0] == "login":
					if data[1] == pwd:
						ip_addresses["192.168.0.5"]["status"] = true
						return "CODE 200: OK"
					else:
						"CODE 401: Authentication failed"
				elif data[0] == "sitemap":
					return "ERROR 405: method not allowed"
			else:
				return "ERROR 400: bad request"
			)
	}
}


var packets : Array = []
var connection : String = ""
var response = ""


func main(data : Array = []):
	computer.make_program_current(self)
	computer.printv("[center][i][font_size=32][color=\"#ffbb00\"]NET[/color][color=\"#ff5500\"]WALKER[/color][/font_size][color=\"#ff0000\"]v1.5[/color][/i][/center]\n")
	computer.printv("Type \"help\" to get help for the program\n")
	waiting_input = true


func process(delta, data : Array = []):
	pass


func accept_input(data : String = ""):
	var parsed = data.split(" ")
	if parsed.size() <= 0:
		return
	
	handle_command(parsed)


func api(data : String):
	if data == "last_response":
		return response

# -----------------------------

func handle_command(data : Array[String]):
	if data[0] == "connect":
		if data.size() < 2:
			computer.printv("Too few arguments. Type \"help connect\" to get help for this command\n")
			return
		
		var regex : RegEx = RegEx.create_from_string('^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$')
		var _match = regex.search(data[1])
		if !_match:
			computer.printv("Incorrect ip address pattern\n")
			return
		if !(_match.get_string() in ip_addresses.keys()):
			computer.printv("RCODE:3 NXDOMAIN: domain name or ip address don\'t exists\n")
			return
		
		connection = _match.get_string()
		computer.printv("RCODE:0 : connected to {0}\n".format([data[1]]))
	elif data[0] == "disconnect":
		computer.printv("Disconnected from {0}\n".format([connection]))
		connection = ""
	elif data[0] == "add-packet":
		packets.append(data.slice(1))
		computer.printv("Packet added\n")
		
	elif data[0] == "print-packets":
		for p in packets:
			if p is Array:
				computer.printv(" ".join(p) + "\n")
			else:
				computer.printv("{0}\n".format(p))
	elif data[0] == "clear-packets":
		packets = []
		computer.printv("Packets cleared\n")
	elif data[0] == "send-request":
		if !(connection in ip_addresses.keys()):
			computer.printv("NETWALKER ERROR: not connected\n")
		var ret = ip_addresses[connection]["callable"].call(packets)
		if !ret:
			computer.printv("RESPONSE: [color=\"#999999\"]null[/color]\n")
		elif ret.begins_with("ERROR"):
			computer.printv("RESPONSE: [color=\"#ff9696\"]{0}[/color]\n".format([ret]))
		else:
			computer.printv("RESPONSE: [color=\"#b8ff96\"]{0}[/color]\n".format([ret]))
		response = ret
		packets = []
	elif data[0] == "exit" || data[0] == "quit":
		computer.printv("Netwalker session ended. Thank you for use [i][color=\"#ffbb00\"]NET[/color][color=\"#ff5500\"]WALKER[/color][/i]\n")
		end()
	else:
		computer.printv("Unexistent command {0}\n".format([data[0]]))
