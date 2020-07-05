const io = require('socket.io-client');
const socketClient = io.connect('http://localhost:8888');

socketClient.on('connect', () => {
  socketClient.emit('kill_sv');
  setTimeout(() => {
    process.exit(0);
  }, 1000);
});