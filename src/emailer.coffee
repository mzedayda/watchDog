fs = require 'fs'

email   = require "emailjs"
server  = email.server.connect
   user:    "********",  # User details here 
   password:"********", 
   host:    "smtp.gmail.com", 
   ssl:     true

lastTime = new Date()
now = new Date()

if not fs.existsSync './Thumbs'
	fs.mkdirSync './Thumbs'

fs.watch './Thumbs', (event, filename) =>
	now = new Date()
	if now.getTime() - lastTime.getTime() > 60000 # one minute
		lastTime = now
		sendMessege()
		console.log "called sendMessege with" + filename
	

sendMessege = () =>
	messege =
		text:    new Date().toString()
		from:    "Alarm <mzedayda@gmail.com>" 
		to:      "Ron <mzedayda@gmail.com>"
		subject: "change detected" + new Date().toString()

	server.send messege, (err, message) ->
		console.log err if err
		console.log "messege sent"
