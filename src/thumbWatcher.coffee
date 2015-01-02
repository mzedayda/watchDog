ffmpeg = require 'fluent-ffmpeg'

command = ffmpeg();

command.input('/dev/video0').inputFormat('video4linux2')
.output('http://localhost:8082/mzedayda/640/480/').outputOptions('-r 25').toFormat('mpeg1video')
.run()
