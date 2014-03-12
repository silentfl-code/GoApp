import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert';

@CustomTag('go-app')
class GoApp extends PolymerElement {
  @observable bool applyAuthorStyles = true;
  Map mainmenuItems = new Map();  //
  
  WebSocket ws;

  GoApp.created() : super.created(){
	mainmenuItems['newGame'] = $['newGame'];
    mainmenuItems['webChat'] = $['webChat'];
    
    $['mainMenu'].items = mainmenuItems;
    $['newGame'].CreateNewGame = CreateNewGame;
	
	//debug
	$['webChat'].visible = true;
	
	ws = initSocket();
  }
  
  WebSocket initSocket([int retrySeconds = 2]) {
    if (retrySeconds > 512) {
	  $['webChat'].Print('Error connecting');
	  return null;
    }
	//print('ws://${Uri.base.host}:${Uri.base.port}/ws');
	WebSocket ws = new WebSocket('ws://${Uri.base.host}:${Uri.base.port}/ws');
    ws.onOpen.listen((e) { $['webChat'].Print('Connect'); });
    ws.onError.listen((e) {
      $['webChat'].Print('Error connecting');
      /* RELEASE MODE
      $['webChat'].Print('Error connecting. Trying reconnect in ${retrySeconds*2} seconds'); 
      new Timer(new Duration(seconds:retrySeconds), () => initSocket(retrySeconds * 2));
      */
    });
    ws.onMessage.listen(Receive); 
	$['webChat'].wsSend = Send;
    return ws;
  }

	//отправляет сообщение на удаленный вебсокет
  void Send(e) {
    ws.send(JSON.encode(e));
  }
  
  //получение сообщения от удаленного узла по протоколу websocket
  void Receive(e) {
    //print('Receive: ' + e.data.toString());
    var msg = JSON.decode(e.data);
    switch (msg["types"]) {
      case "message":
        $['webChat'].Print(msg["user"] + '>' +msg["message"]);
        break;
      case "users":
        $['webChat'].UsersUpdate(msg);//RefreshUsersList(msg);
		print(msg);
        break;
    }
  }
  
  void CreateNewGame(Map data) {
    print(data);
  }
}