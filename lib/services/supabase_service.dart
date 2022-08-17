import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends ChangeNotifier {
  // create function which takes one argument of user Phone number to be stored in the database
  // Future<PostgrestResponse<dynamic>> createData() async {
  //   PostgrestResponse<dynamic> res = await Supabase.instance.client
  //       .from('users')
  //       // here 👇 you need to make todo.toMap() because we need to make Todo model to map --> eg  Todo(title: 'This is first todo') -> {'title': 'This is first todo'}
  //       .insert(todo.toMap())
  //       .execute();

  //   return res;
  // }

}
