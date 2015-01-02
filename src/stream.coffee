STREAM_PORT = 8082
STREAM_SECRET = 'mzedayda'
WEBSOCKET_PORT = 8080
STREAM_MAGIC_BYTES = 'jsmp' # Must be 4 bytes

clients = {}
width = 320
height = 240

# Websocket Server
socketServer = new (require('ws').Server)({port: WEBSOCKET_PORT})
_uniqueClientId = 1

socketError = () -> {}
socketServer.on 'connection', (socket) ->
	# Send magic bytes and video size to the newly connected socket
	# struct { char magic[4] unsigned short width, height}
	streamHeader = new Buffer(8)
	streamHeader.write(STREAM_MAGIC_BYTES)
	streamHeader.writeUInt16BE(width, 4)
	streamHeader.writeUInt16BE(height, 6)
	socket.send(streamHeader, {binary:true}, socketError)

	# Remember client in 'clients' object
	clientId = _uniqueClientId++
	clients[clientId] = socket

	console.log 'WebSocket Connect: client #' + clientId + ' ('+Object.keys(clients).length+' total)'

	# Delete on close
	socket.on 'close', (code, message) ->
		delete clients[clientId]
		console.log 'WebSocket Disconnect: client #' + clientId + ' ('+Object.keys(clients).length+' total)'


# HTTP Server to accept incomming MPEG Stream
streamServer = require('http').createServer (request, response) ->
	params = request.url.substr(1).split('/')
	width = (params[1] || 320)|0
	height = (params[2] || 240)|0

	if params[0] is STREAM_SECRET
		console.log 'Stream Connected: ' + request.socket.remoteAddress + ':' + request.socket.remotePort + ' size: ' + width + 'x' + height
		request.on 'data', (data) ->
			for clientId, client of clients
				client.send(data, {binary:true}, socketError)
	else
		console.log 'Failed Stream Connection: '+ request.socket.remoteAddress + request.socket.remotePort + ' - wrong secret.'
		response.end()
		
.listen(STREAM_PORT)

console.log('Listening for MPEG Stream on http://127.0.0.1:'+STREAM_PORT+'/<secret>/<width>/<height>')
console.log('Awaiting WebSocket connections on ws://127.0.0.1:'+WEBSOCKET_PORT+'/')
