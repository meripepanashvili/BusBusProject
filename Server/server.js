

var socket1 = null
var socket2 = null

var app = require('http').createServer()

app.listen(8084)


var io  = require('socket.io')(app)

io.sockets.on("connection", function(socket) {
	if ( socket1 == null ){
		console.log(" socket1 shemovida")
		socket1 = socket
		//socket1.emit("partner text", "alala")
	}
	else if( socket2 == null ){
		socket2 = socket
		socket1.emit("partner found")
		socket2.emit("partner found")
		socket1.emit("partner text", "megobari mogivida")
		console.log("socket2 shemovida")		
		socket2.on("chat", function( msg) {
			socket1.emit("partner text" ,msg)
		})
		socket1.on("chat", function(msg){
			socket2.emit("partner text" ,msg)
		})

		socket1.on('disconnect', function() {
    		if(socket2){
    			socket2.emit("partner disconnect")    			
			socket2.disconnect()
			console.log("meore socket arsebobs da vrtav")    	
		}
    		socket1 = null
    		socket2 = null


   		});

		socket2.on('disconnect', function() {
    		if(socket1){
		 	console.log("meore socket arsebobs da vrtav")
    			socket1.emit("partner disconnect")
    			socket1.disconnect()
		}
    		socket2 = null
    		socket1 = null
   		});

	}
	
	
    
})


 
