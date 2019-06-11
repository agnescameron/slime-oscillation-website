// Setup basic express server
var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

// Change 3000 to whatever port, you want to access the site with"http://127.0.0.1:3000"
var port = process.env.PORT || 3000;

server.listen(port, function() {
    console.log("Server listening at port "+port);
});

var dir = __dirname+'/public'; // Path of the index.js but one dir further (public)
app.use(express.static(dir));