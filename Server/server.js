

var socket1 = 0
var socket2 = 0

var app = require('http').createServer()

app.listen(8084)


var io  = require('socket.io')(app)

io.sockets.on("connection", function(socket) {
	if (  socket1 == 0  ){
		console.log(" socket1 shemovida")
		socket1 = socket
		//socket1.emit("partner text", "alala")
	}
	else if( socket2 == 0 ){
		socket2 = socket
		//console.log(socket1)
		//console.log(socket2)
		socket1.emit("partner found")
		socket2.emit("partner found")
		socket1.emit("get location")
		socket2.emit("get location")
	//	socket1.emit("partner text", "megobari mogivida")
		console.log("socket2 shemovida")		
		socket2.on("chat", function( msg) {
			socket1.emit("partner text" ,msg)
		})
		socket1.on("chat", function(msg){
			socket2.emit("partner text" ,msg)
		})

		socket1.on("make sound", function(){
			socket2.emit("make sound")
		})

		socket2.on("make sound", function(){
			socket1.emit("make sound")
		})

		socket1.on('disconnect', function() {
			socket1 = 0
    		if( socket2 != 0 ){		
				socket2.disconnect()
				console.log("meore socket arsebobs da vrtav")    	
			}    		
    		socket2 = 0
   		});

		socket2.on('disconnect', function() {
			socket2 = 0
    		if( socket1 != 0){
		 		console.log("pirveli socket arsebobs da vrtav")
    			socket1.disconnect()				
			}    		
    		socket1 = 0
   		});

   	}
	
	socket.on('recieve location', function(data1, data2){
		console.log(data1 + "  " + data2)

	});
	socket.emit("get bus number")

	socket.on('bus number', function(busNum){
		console.log(busNum)

	});
    
})

// var room  = "two person"
// var connected = 0
// io.sockets.on("connection", function(socket) {
// 	console.log("kavshiri")
// 	console.log(connected)
// 	connected++
// 	socket.join(room)

// 	if ( connected == 2 ) {
// 		console.log("shemovedit")
// 		io.sockets.in(room).emit("partner found")
// 		//var roster = io.sockets.clients('chatroom1')
//  	var r = Object.keys(socket.adapter.rooms[room])
// 	 console.log(r.length)
// //	 for (var sock in r){
// //		sock.leave(room)
// //		sock.disconnect()
// //		}
// // roster.forEach(function(client) {
// //     console.log('Username: ' + client.nickname)
// // })
// 			io.sockets.clients(someRoom).forEach(function(s){
//     		s.leave(someRoom)
// 		})
// 	}

// 	socket.on("chat", function(msg){
// 		io.sockets.in(room).emit("partner text" ,msg, socket.id)
// 	})



// 	socket.on("disconnect", function(){
// 		connected = 0
// 		// roomRes = io.sockets.adapter.rooms[room];
// 		// if (room) {
//   //   		for (var id in roomRes) {
//   //   			io.sockets.adapter.nsp.connected[id].leave(room)
// 		// 		io.sockets.adapter.nsp.connected[id].disconnect()
//   //   		}
// 		// }
// //		var namespace = '/'
// //		var roomCollect = io.nsps[namespace].adapter.rooms[room]
// //		for (var sock in roomCollect){
// //			sock.leave(room)
// //		}
// //		console.log(Object.keys(room).length)
		
// 		// var rooms = io.sockets.manager.roomClients[socket.id];
//   //      for(var room in rooms) {
//   //          socket.leave(room);
//   //      }
	
// })

 
// })
