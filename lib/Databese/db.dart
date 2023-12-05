import 'package:hive/hive.dart';

// ignore: camel_case_types
class database{
  late Box box;

  database(){
    openBox();
  }

  openBox(){
    box = Hive.box('money');
  }

  Future addData(int amount,DateTime date,String type,String mode,String note) async{
    var values = {'amount': amount,'date': date,'type': type,'mode': mode,'note': note};
    box.add(values);
  }

  Future<Map> fetch(){
    if(box.values.isEmpty){
      return Future.value({});
    }else{
      return Future.value(box.toMap());
    }
  }
}