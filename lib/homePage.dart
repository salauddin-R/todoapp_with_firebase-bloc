import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit.dart';

class HomePage extends StatelessWidget {
    HomePage({super.key});
  TextEditingController _controller=TextEditingController();
  void addItemData(BuildContext context,String? id,String name){
    _controller.text=name;
   showDialog(context: context,
       builder:(context)=>AlertDialog(
         title: Text(id==null?"Create new Item":"Update new Item"),
         content:TextField(controller: _controller,),
         actions: [
           ElevatedButton(onPressed:(){
             Navigator.pop(context);
           }, child:Text("Chancel")),
           ElevatedButton(onPressed:(){
             if(_controller.text.isEmpty){
               Navigator.pop(context);
             }
             else if(id==null){
               context.read<cubitPage>().addData(_controller.text);
             }
             else{
             context.read<cubitPage>().updateData(id,_controller.text);
             }
             Navigator.pop(context);
           }, child:Text("Save")),
         ],
       )
   );
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title:Text("To Do List with Firebase",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,color:Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<cubitPage,List<Map<String,dynamic>>>(builder:(context,state){
        return ListView.builder(
          itemCount: state.length,
            itemBuilder:(context,index){
              return Card(
                margin: EdgeInsets.only(top:7),
                color: Colors.white,
                child: ListTile(
                  title: Text(state[index]["name"],style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20,color:Colors.black)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed:(){
                        addItemData(context,state[index]["id"],state[index]["name"]);
                      }, icon:Icon(Icons.edit)),
                      IconButton(onPressed:(){
                        context.read<cubitPage>().deleteData(state[index]["id"]);
                      }, icon:Icon(Icons.delete)),
                    ],
                  ),
                ),
              );
            }
        );
      }),
      floatingActionButton: FloatingActionButton(onPressed:(){
        addItemData(context,null,"");
      },child: Icon(Icons.add),),
    );
  }
}
