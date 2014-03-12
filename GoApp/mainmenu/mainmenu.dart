import 'package:polymer/polymer.dart';

@CustomTag('main-menu')
class MainMenu extends PolymerElement {
  @observable bool applyAuthorStyles = true;
  @published Map items;
  
  MainMenu.created() : super.created();
  
  void Click(var event, var detail, var target) {
    items.forEach((key, value) {items[key].visible = false; });
    items[target.attributes['data-item']].visible = true;
    //print(target.attributes['data-item'].visible);
    //item.visible = true;
  }
}