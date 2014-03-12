import 'package:polymer/polymer.dart';
//import 'dart:async';

@CustomTag('new-game')
class NewGame extends PolymerElement {
  @observable bool applyAuthorStyles = true;
  @published bool visibleValue = false;

  @observable Map data = toObservable({
	'size': 2,		//9, 13, 19
	'color': 0,		//auto, black, white
	'komi': 1		//5.5, 6.5, 7.5
  });
  var CreateNewGame;  //ссылка на функцию, которая описана в goApp 
  
  
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
    
  NewGame.created() : super.created() {
  }
  
  void CreateNewGameClick() {
    CreateNewGame(data);
  }
}