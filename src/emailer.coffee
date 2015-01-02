fs = require 'fs'
email   = require "emailjs"

server  = email.server.connect
   user:    "********",  # User details here 
   password:"********", 
   host:    "smtp.gmail.com", 
   ssl:     true

if not fs.existsSync './Thumbs'
	fs.mkdirSync './Thumbs'

lastTime = new Date()

sendMessege = (time) ->
	messege =
		text:    time.toString()
		from:    "Alarm <alarm@gmail.com>" 
		to:      "User Name <User Mail>"
		subject: "Change detected" + time.toString()

	server.send messege, (err, message) ->
		console.log err if err
		console.log "messege sent"

fs.watch './Thumbs', (event, filename) =>
	now = new Date()
	if now.getTime() - lastTime.getTime() > 60000 # one minute
		lastTime = now
		sendMessege now	
