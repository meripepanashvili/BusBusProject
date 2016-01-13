

var socket1 = false
var socket2 = false

var app = require('http').createServer()

app.listen(8084)


var io  = require('socket.io')(app)

io.sockets.on("connection", function(socket) {
 socket.emit("partner found", "alala")
	if (!socket1){
		socket1 = socket
		socket1.emit("partner found", "alala")
	}
	else if(!socket2){
		socket2 = socket
		socket1.emit("partner found")
		socket2.emit("partner found")

		
		socket2.on("chat", function( msg) {
			socket1.emit("partner text" ,msg)
		})
		socket1.on("chat", function(msg){
			socket2.emit("partner text" ,msg)
		})

		socket1.on('disconnect', function() {
    		if(socket2){
    			socket2.emit("partner disconnect")
    		}
    		socket1 = false
    		socket2 = false
   		});

		socket2.on('disconnect', function() {
    		if(socket1){
    			socket2.emit("partner disconnect")
    		}
    		socket1 = false
    		socket2 = false
   		});

	}
	
	
    
})


 
