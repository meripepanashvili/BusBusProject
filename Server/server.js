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


var app = require('http').createServer()

app.listen(8900)


var io  = require('socket.io')(app)

io.sockets.on("connection", function(socket) {
        colsole.log("connected")
})
