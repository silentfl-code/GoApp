import 'package:polymer/polymer.dart';
//import 'dart:html';
//import 'dart:async';
//import 'dart:convert';

void main() {
  
  initPolymer();

  //new Application();
}

class Application {
  
}

/*
class Client {
  var tab0, tab1, tab2;
  var nav_start, nav_chat, nav_games;  //пункты меню
  var newGame;  //кнопка Создать игру
  var messages; //лог сообщений textarea
  var message;  //элемент input с отправляемым сообщением
  var users;    //элемент textarea - список пользователей
  var usersCount;  //элемент "количество пользователей онлайн"
  WebSocket ws;
  WebSocket needReload;
  Map userlist = new Map();

  
  Client() {
    //инициализация элементов интерфейса
    var send = querySelector('#send');
    messages = querySelector('#messages');
    message = querySelector('#message');
    users = querySelector('#users');
    tab0 = querySelector('#tab0');
    tab1 = querySelector('#tab1');
    tab2 = querySelector('#tab2');
    nav_start = querySelector('#nav_start');
    nav_chat = querySelector('#nav_chat');
    nav_games = querySelector('#nav_games');
    usersCount = querySelector('#usersCount');
    newGame = querySelector('#newGame');
    
    //release version
    //tab1.style.display = 'inherit';
    
    //debug version
    tab0.style.display = 'inherit';
    
    //вешаем обработчики событий
//    message.onKeyPress.listen(TrySendMessage);
//    send.onClick.listen(SendMessage);
//    nav_start.onClick.listen(ViewStartGame);
//    nav_chat.onClick.listen(ViewChat);
//    nav_games.onClick.listen(ViewGames);
//    newGame.onClick.listen(NewGame);

    //вебсокет
    ws = initSocket();
  }
  
  //кнопка меню: старт новой игры
  void ViewStartGame(MouseEvent event) {
    tab0.style.display = 'inherit';
    tab1.style.display = 'none';
    tab2.style.display= 'none';
  }
  
  //кнопка меню: просмотр чата
  void ViewChat(MouseEvent event) {
    tab0.style.display = 'none';
    tab1.style.display = 'inherit';
    tab2.style.display = 'none';    
  }
  
  //кнопка меню: просмотр игр
  void ViewGames(MouseEvent event) {
    tab0.style.display = 'none';
    tab1.style.display = 'none';
    tab2.style.display = 'inherit';    
  }
  
  WebSocket initSocket([int retrySeconds = 2]) {
    if (retrySeconds > 512) {
      AddMessage('Error connecting');
      return null;
    }
    ws = new WebSocket('ws://localhost:8080/ws');  //TO DO: ws://${Uri.base.host}:${Uri.base.port}/ws
    ws.onOpen.listen((e) { AddMessage('Connect'); });
    ws.onError.listen((e) {
      AddMessage('Error connecting');
      /* DEBUG MODE
      AddMessage('Error connecting. Trying reconnect in ${retrySeconds*2} seconds'); 
      new Timer(new Duration(seconds:retrySeconds), () => initSocket(retrySeconds * 2));
      */
    });
    ws.onMessage.listen(Receive); 
    return ws;
  }
  
  //отправляет сообщение на удаленный вебсокет
  void Send(e) {
    //print('Send');
    ws.send(JSON.encode(e));
  }
  
  //получение сообщения от удаленного узла по протоколу websocket
  void Receive(e) {
    //print('Receive: ' + e.data.toString());
    var msg = JSON.decode(e.data);
    switch (msg["types"]) {
      case "message":
        AddMessage(msg["user"] + '>' +msg["message"]);
        break;
      case "users":
        RefreshUsersList(msg);
        break;
    }
  }
  
  //обработка события "нажатие на клавишу в message"
  void TrySendMessage(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ENTER) {
      SendMessage(null);
    }
  }
  
  //обработка события "Send" (отправить сообщение)
  void SendMessage(MouseEvent e) {
    if (message.value != '') {
      Send({'types':'message','message':'${message.value}'});
      message.value = '';
    }
  }
  
  //добавляет сообщение в лог сообщений
  void AddMessage(String msg) {
    messages.value = messages.value + msg + '\n';
  }
  
  //обработка событий на вход/выход пользователей
  void RefreshUsersList(Map message) {
    print('RefreshUserList');
    print(message);
    bool refresh = false;
    switch (message['action']) {
      case 'add':
        var users = JSON.decode(message['users']);
        users.forEach((user) => userlist[user['Nickname']] = user['Rank']);
        refresh = true;
        break;
      case 'del':
        var user = JSON.decode(message['users']);
        userlist.remove(user['Nickname']);
        refresh = true;
        break;
    }
    if (refresh) {
      String list = '<table class="table table-striped table-hover">';
      userlist.forEach((key, value) => list += '<tr><td>'+key+'</td><td>'+value+'</td>');
      list += '</table>';
      users.innerHtml = list;
      usersCount.innerHtml = 'Users online: ' + userlist.length.toString();  //плохо, что код и js в одну кучу
    }
  }
}
*/