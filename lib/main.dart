import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit.dart';
import 'homePage.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>cubitPage()..fetchData(),
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ) ,
    );
  }
}
