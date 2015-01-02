express = require 'express'
path = require 'path'

app = express()

clientRoot = path.resolve './src'
app.set 'port', 8000

app.get '/', (req, res) ->
	# console.log 'got req'
	res.sendFile path.join clientRoot, '/streamPage.html'

app.get '/jsmpg.js', (req, res) ->
	res.sendFile path.join clientRoot, '/jsmpg.js'

# app.get '/vid1.webm', (req, res) ->
# 	console.log 'gdskgnskg'
# 	res.contentType 'flv'
# 	command = ffmpeg(clientRoot + '/vid1.webm')
# 	.preset('flashvideo')
# 	.pipe res, {end: true}

# app.use express.static clientRoot

app.listen app.get('port'), () ->
	console.log "App is now listening to port " + app.get 'port'