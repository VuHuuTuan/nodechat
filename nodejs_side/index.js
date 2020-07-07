/**
 * Tham khảo các lệnh emit socketIO: https://viblo.asia/p/tat-tan-tat-nhung-lenh-emit-trong-socketio-Qbq5Qj8wKD8
 */

const port = 8888;
const db_name = "demomongo";

const Express = require('express');
const Mongoose = require("mongoose");
const BodyParser = require('body-parser');

Mongoose.connect("mongodb://localhost/"+db_name, {
  useNewUrlParser: true, 
  useCreateIndex: true, 
  useUnifiedTopology: true
});

var app = Express();

app.use(BodyParser.json());
app.use(BodyParser.urlencoded({extended: true}));

var server = require('http').createServer(app);
var io = require('socket.io')(server);

//#region API - Define REST API
app.get('/', async (req,res) => {
  res.send("Your NodeJs server is running. Yay!!");
});

app.get('/database/drop/', async (req,res) => {
  await Mongoose.connection.db.dropDatabase();
  res.send("Database named was droped: "+db_name);
});

//#region user_collection
app.get('/users/', async (req,res) => {
  try{
    var user = await UserModel.find().select("-password").exec();
    res.send(user);
  }catch (error){
    res.status(999).send(error);
  }
});

app.post('/user/key/', async (req,res) => {
  try{
    var user = await UserModel.findOne({key:req.body.key}).select("-password").exec();
    var exits = user != null;
    if(!exits) {
      var new_user = new UserModel({
        key: req.body.key,
        body: req.body.body,
        off_time: null,
      });
      user = await new_user.save();
    }else{
      user.set({body: req.body.body});
      user = await user.save();
    }
    res.send(user);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});

app.post('/user/keys/', async (req,res) => {
  try{
    var keys = req.body.keys;
    var bodys = req.body.bodys;
    var users = await Promise.all(keys.map(async key => {
      var index = keys.indexOf(key);
      var user = await UserModel.findOne({key:key}).select("-password").exec();
      var exits = user != null;
      if(!exits) {
        var new_user = new UserModel({
          key: key,
          body: bodys == null ? null : bodys[index],
          off_time:null,
        });
        user = await new_user.save();
      }else{
        user.set({body: bodys == null ? null : bodys[index]});
        user = await user.save();
      }
      return user;
    }));
    res.send(users);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});

app.get('/user/id/:id', async (req,res) => {
  try{
    var user = await UserModel.findById(req.params.id).select("-password").exec();
    res.send(user);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});

app.put('/user/id/:id', async (req,res) => {
  try{
    var user = await UserModel.findById(req.params.id).exec();
    user.set(req.body)
    var result = await user.save();
    res.send(result);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});

app.get('/users/:ids', async (req,res) => {
  try{
    var ids = req.params.ids.split(",");
    var users = await UserModel.find({_id: {"$in": ids}}).select("-password").exec();
    res.send(users);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});

app.post('/users/search/', async (req,res) => {
  try{
    //Partial text search
    var users = await UserModel.find({
      $and: [
        { _id: {
          $ne: req.body.your_id
        }},
      ],
      name: {
        $regex: ".*" +req.body.key +".*", 
        $options: 'i'
      }
    }).select("-password").exec();
    res.send(users);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});
//#endregion

//#region conv_collection
app.get('/conv/id/:id', async (req,res) => {
  try{
    var conv = await ConversationModel.findById(req.params.id).exec();
    res.send(conv);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});

app.post('/conv/members/', async (req,res) => {
  try{
    var conversation = await ConversationModel.findOne({members: {"$in":req.body.ids}}).exec();
    var exits = conversation != null;
    if(!exits) {
      var new_conv = new ConversationModel({members: req.body.ids[0]});
      conversation = await new_conv.save();
    }
    res.send(conversation);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});
//#endregion

//#region mess_collection
app.get('/message/:id', async (req,res) => {
  try{
    var message = await MessageModel.findById(req.params.id).exec();
    res.send(message);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});

app.get('/messages/:id', async (req,res) => {
  try{
    var messages = await MessageModel.find({conversation_id: req.params.id}).exec();
    res.send(messages);
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});
//#endregion

//#region other_collection
app.post('/other/get_holder_by_member/', async (req,res) => {
  try{
    var conversation = await ConversationModel.findOne({members: {"$in":req.body.ids}}).exec();
    var exits = conversation != null;
    if(!exits) {
      var new_conv = new ConversationModel({members: req.body.ids[0]});
      conversation = await new_conv.save();
    }
    var user = await UserModel.findById(req.body.andId).exec();
    var messages = await MessageModel.find({conversation_id: conversation._id});
    var unseen = messages.filter(mess => mess.seeners.indexOf(req.body.yourId) == -1);
    res.send({
      conversation_id: conversation._id,
      user_key: req.body.andId,
      off_time: user.off_time,
      body: user.body,
      unseen_count: unseen.length,
      last_message_content: messages.length > 0 ? messages[messages.length - 1].content : null,
      last_message_type: messages.length > 0 ? messages[messages.length - 1].type : null,
    });
  }catch (error){
    console.log(error);
    res.status(999).send(error);
  }
});
//#endregion

//#endregion

//#region MODEL - Configure mongo model
var Schema = Mongoose.Schema;
const UserSchema = Schema({
  key: {type:String, unique:true},
  off_time: {type: String},
  body: {type: Map},
});
UserSchema.index({name: 'text'});
const UserModel = Mongoose.model("users", UserSchema);
const ConversationModel = Mongoose.model("conversations", {
  members: [String],
});
const MessageModel = Mongoose.model("messages", {
  conversation_id: String,
  sender_id: String,
  sender_time: String,
  type: String,
  is_deleted: Boolean,
  content: String,
  data: String,
  seeners: [String]
});
//#endregion

//#region SocketIO
io.on("connection", socket => {
  //get convID and join to it
  var convID = socket.handshake.query.convID;
  var userID = socket.handshake.query.userID;
  socket.join(convID);
  console.log("SocketIO: "+userID+" has joining room "+convID);

  /* Get out of the room of convID */
  socket.on('disconnect', () => {
    console.log("SocketIO: "+userID+" has left");
    socket.leave(convID)
  })
  
  socket.on("message_send", async (msg) => {
    try{
      // console.log(msg);
      var message = new MessageModel(msg);
      var createResult = await message.save();
      // console.log(createResult);
      socket.emit("receive_message", createResult);
      socket.emit("update_conversation_holder", null);
      socket.broadcast.to(convID).emit("receive_message", createResult);
      socket.broadcast.to(convID).emit("update_conversation_holder", null);
    }catch(e){
      console.log(e);
    }
  });
  
  socket.on("conversation_seen", async (data) => {
    try{
      console.log("conversation_seen: "+data.conversation_id+"/"+data.user_id);
      MessageModel.updateMany({
        conversation_id: data.conversation_id,
      },{
        '$addToSet': {'seeners':data.user_id}
      }).exec();

      socket.emit("update_conversation_holder", null);
    }catch(e){
      console.log(e);
    }
  });
  
  /* KILL SERVER - Type: \> node stop_sv.js */
  socket.on("kill_sv", () => {
    console.log("Server was killed!");
    process.exit(0);
  });
})
//#endregion

server.listen(port, () => {
  console.log("Listening at port "+port+"...");
});