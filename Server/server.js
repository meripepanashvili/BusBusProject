// var app = require('express')();
// var http = require('http').Server(app);
// var io = require('socket.io')(http);



// io.on('connection', function(socket){
//   console.log('a user connected');

//   socket.on('disconnect', function(){
//     console.log('user disconnected');
//   });

//   socket.on('chat message', function(msg){
//     console.log('message: ' + msg);
//   });
// });

// http.listen(8900, function(){
//   console.log('listening on *:8900');
// });

var socket1 = false
var socket2 = false

var app = require('http').createServer()

app.listen(8084)


var io  = require('socket.io')(app)

io.sockets.on("connection", function(socket) {
	if (!socket1){
		socket1 = socket
		socket1.emit("partner text", "alala")
	}
	else if(!socket2){
		socket2 = socket
		socket2.on("chat", function( msg) {
			socket1.emit("partner text" ,msg)
		})
		socket1.on("chat", function(msg){
			socket2.emit("partner text" ,msg)
		})
	}
	
    
})


 
