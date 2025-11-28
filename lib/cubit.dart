import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class cubitPage extends Cubit<List<Map<String,dynamic>>>{
  cubitPage():super([]);
  FirebaseFirestore _db=FirebaseFirestore.instance;
  Future<void> fetchData()async{
    await _db.collection("items").snapshots().listen((doc){
      List<Map<String,dynamic>> item=[];
      for(var data in doc.docs){
        item.add({
          "id":data.id,
          ...data.data()as Map<String,dynamic>
        });
      }
      emit(item);
    });
  }
  void updateData(String id,String name){
     _db.collection("items").doc(id).update({"name":name});
  }
  void deleteData(String id){
     _db.collection("items").doc(id).delete();
  }
  void addData(String name){
    _db.collection("items").add({"name": name});
  }
}