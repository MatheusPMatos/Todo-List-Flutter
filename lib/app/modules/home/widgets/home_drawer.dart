import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_provider/app/core/auth/auth_provider.dart';
import 'package:todolist_provider/app/core/ui/messages.dart';
import 'package:todolist_provider/app/core/ui/theme_extensions.dart';
import 'package:todolist_provider/app/services/tasks/tasks_service.dart';
import 'package:todolist_provider/app/services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {

  final nameVN = ValueNotifier<String>('');

   HomeDrawer({ super.key });

   @override
   Widget build(BuildContext context) {
       return  Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration( 
                    color: context.primaryColor.withAlpha(70)
                  ),
                  child: Row(
                    children: [
                      Selector<AuthProvider, String>(
                        builder: (_, value, __){
                         return CircleAvatar(
                            backgroundImage: NetworkImage(value),
                            radius: 30,
                          );
                        }, 
                        selector: (context, authprovider){
                        return authprovider.user?.photoURL ?? 'https://avatarfiles.alphacoders.com/155/155019.jpg';
                      }),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Selector<AuthProvider, String>(
                        builder: (_, value, __){
                         return  Text( value, style: context.textTheme.titleMedium,);
                        }, 
                        selector: (context, authprovider){
                        return authprovider.user?.displayName ?? 'Não informado';
                      })    
                        ),
                        ),
                    ],
                  )),
                  ListTile(
                    onTap: () {
                      showDialog(context: context, builder: (_){
                        return AlertDialog(
                          title: const Text('Alterar Nome'),
                          content:TextField(
                            onChanged: (value) => nameVN.value = value ,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop() , 
                              child:const Text('Cancelar', style: TextStyle(color: Colors.red),),
                              ),
                            TextButton(
                              onPressed: () async {
                                final nameValue = nameVN.value;
                                if(nameValue.isEmpty){
                                  Messages.of(context).showError('Nome obrigatório');
                                }else {
                                  
                                   await context.read<UserService>().updateDisplayName(nameValue);
                                  
                                   Navigator.of(context).pop();
                                }
                              }, 
                              child: const Text('Alterar'))
                          ],
                        );
                      });
                    },
                    title: const Text('Alterar Nome'),
                  ),
                  ListTile(
                    title:const  Text('Sair'),
                    onTap: () {
                      context.read<TasksService>().resetDb();
                      context.read<AuthProvider>().logout();
                      
                    }
                  ),
              ],
            ),
           );
       
  }
}