var net = require('net');
var chat_io = require('socket.io').listen(9096);

chat_io.sockets.on('connection', function (socket) {
  socket.on('join_room', function (game_id) {
    socket.join(game_id);
  });
  socket.on("distribute_chat_message", function (data){
    chat_io.sockets.in(data.game_id).emit("receive_chat_message", { email: data.email, message: data.message });
  });
});

net.createServer(function (s)
{
  var raw = "";
  s.setEncoding("UTF8");
  s.on("data", function (data)
  {
    raw += data;
  });
  s.on("end", function()
  {
    var parsed_json = JSON.parse(raw);
    chat_io.sockets.in(parsed_json.game_id).emit(parsed_json.event, parsed_json);
  });
}).listen(9095, "0.0.0.0");