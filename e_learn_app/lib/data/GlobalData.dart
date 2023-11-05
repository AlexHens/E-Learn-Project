
class GlobalData {

  static GlobalData? _instance;

  String dni = '';

  GlobalData._();

  static GlobalData? getInstance() {
    if(_instance == null){
      _instance = GlobalData._();
    }

    return _instance; 
  }

  GlobalData._internal();

}