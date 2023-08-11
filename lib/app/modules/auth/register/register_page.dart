import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todolist_provider/app/core/ui/theme_extensions.dart';
import 'package:todolist_provider/app/core/validators/validators.dart';
import 'package:todolist_provider/app/core/widgets/todo_list_field.dart';
import 'package:todolist_provider/app/core/widgets/todo_list_logo.dart';
import 'package:todolist_provider/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';


class RegisterPage extends StatefulWidget {

  

  RegisterPage({Key? key }): super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();
 



  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    
    super.initState();

    final defaultListener = DefaultListenerNotifier(changeNotifier: context.read<RegisterController>());
    defaultListener.listener(
      context: context, 
      successVoidCallBack:(notifier, listenerInstance){
        listenerInstance.dispose();

        // pop removido devido a alteração no do Idtoken para authprovider
        // Navigator.of(context).pop();
      } );

    // context.read<RegisterController>().addListener(() {
    //   final controller = context.read<RegisterController>(); 
    //   var sucess =  controller.sucess;;
    //   var error = controller.error;
    //   if(sucess){
    //     Navigator.of(context).pushNamed('/login');

    //   }else if(error != null && error.isNotEmpty){
    //     Messages.of(context).showError(error);
    //   }
    // });
  }
  

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Todo List', style: TextStyle(fontSize: 10, color: context.primaryColor),),
                Text('Cadastro', style: TextStyle(fontSize: 15, color: context.primaryColor ),)
              ],
            ),

            leading: IconButton(
              onPressed: (){Navigator.of(context).pushNamed('/login');}, 
              icon: ClipOval(
                      child: Container(
                                color: context.primaryColor.withAlpha(20),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                          Icons.arrow_back_ios_new_outlined, 
                                          size: 20,
                                          color: context.primaryColor,
                                          ),
                              ),
                      ),
                     ),
            ),

           body: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * .5,
                child: const FittedBox(
                  child:  TodoListLogo(),
                  fit: BoxFit.fitHeight,
                ), 
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TodoListField(
                        label:'E-mail',
                        controller: _emailEC,
                        validator: Validatorless.multiple([
                          Validatorless.required('E-mail obrigatório'),
                          Validatorless.email('E-mail inválido')
                        ]),
                        ),

                      const SizedBox(height: 20,),
                      TodoListField(
                        label:'Senha', 
                        obscureText: true,
                        controller: _passwordEC,
                        validator: Validatorless.multiple([
                          Validatorless.required('Senha Obrigatória'),
                          Validatorless.min(6, 'Senha deve conter 6 ou mais caracteres')
                        ]),
                        ),

                      const SizedBox(height: 20,),
                      TodoListField(
                        label:'Comfirmar Senha', 
                        obscureText: true,
                        controller: _confirmPasswordEC,
                        validator: Validatorless.multiple([
                          Validatorless.required('Senha Obrigatória'),
                          Validators.compare(_passwordEC, 'Senha diferente de confirma senha')                         
                        ]),
                        ),
                      const SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                                        onPressed:(){
                                          final formvalid = _formKey.currentState?.validate() ?? false;
                                          if(formvalid) {
                                            final email = _emailEC.text;
                                            final password = _passwordEC.text;
                                            context.read<RegisterController>().registerUser(email, password);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          )
                                        ),
                                        child:const  Padding(
                                          padding:  EdgeInsets.all(10.0),
                                          child:  Text('Salvar'),
                                        ),),
                      )                     
                    ],
                  ) ),               
                )
            ],
           ),
       );
  }
}