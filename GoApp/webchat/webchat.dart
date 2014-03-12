import 'package:polymer/polymer.dart';
import 'dart:convert';
import 'dart:html';

@CustomTag('web-chat')
class WebChat extends PolymerElement {
  @observable bool applyAuthorStyles = true;
  @observable bool visibleValue = false;
  @observable Map <String, String> users = toObservable(new Map<String, String>());
  //за следующие два массива благодарность разработчикам, Map не может быть observable =(
  //bug fix https://code.google.com/p/dart/issues/detail?id=15407
  List users_Nickname = toObservable([]);
  List users_Rank = toObservable([]);

  var wsSend;	//процедура отправки сообщений, назначается владельцем компонента
	    
  bool get visible {
    return visibleValue;
  }
  
  //set visible mode for this element
  //WARNING: don't use statically, only dynamic:
  //OK: $['newGame'].visible = true;
  //WRONG: <new-game visible="true">  (because html-item is not created when property setting)
  void set visible(bool visible) {
    visibleValue = visible;
    $['tab'].style.display = (visible) ? 'inherit' : 'none';
  }
  
  WebChat.created() : super.created() {

  }

  //print message in textarea
  void Print(String message) {
	$['messages'].value += message + '\n';
  }

  void messageKeypress(Event e, var detail, Node target) {
    int code = (e as KeyboardEvent).keyCode;
    switch(code) {
    case 13:
        Send();
    }
  }

  void Send() {
	if ($['message'].value != '') {
      wsSend({'types':'message','message':$['message'].value});
      $['message'].value = '';
	}
  }

  void UsersUpdate(Map msg) {
	  bool refresh = false;
	  switch (msg['action']) {
	    case 'add':
		  var userlist = JSON.decode(msg['users']);
	      userlist.forEach((user) => users[user['Nickname']] = user['Rank']);
	      break;
	    case 'del':
	      var userlist = JSON.decode(msg['users']);
	      users.remove(userlist['Nickname']);
	      break;
	  }
    users_Nickname.clear();
    users_Rank.clear();
    users.forEach((key, value) { users_Nickname.add(key); users_Rank.add(value); });
  }
}