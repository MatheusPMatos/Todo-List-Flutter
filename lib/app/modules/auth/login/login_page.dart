import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:todolist_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todolist_provider/app/core/ui/messages.dart';
import 'package:todolist_provider/app/core/widgets/todo_list_field.dart';
import 'package:todolist_provider/app/core/widgets/todo_list_logo.dart';
import 'package:todolist_provider/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({ super.key });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>()).listener(
      context: context, 
      everVoidCallBack: (notifier, listenerInstance) {
        if(notifier is LoginController){
          if(notifier.hasInfo){
            Messages.of(context).showInfo(notifier.infoMessage!);
          }
        }
      },
      successVoidCallBack: (notifier, listenernotifier){
      });
  }

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView (
                child:  ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.minWidth
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         const SizedBox(height: 10,),
                         const  TodoListLogo(),
                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                           child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TodoListField(
                                  focusNode: _emailFocus,
                                  label: 'E-mail',
                                  controller: _emailEC,
                                  validator: Validatorless.multiple([
                                    Validatorless.required('E-mail obrigatório '),
                                    Validatorless.email('E-mail inválido')
                                  ]) ,),
                                const SizedBox(height: 20,),
                                TodoListField(
                                  label: 'Senha', 
                                  obscureText: true,
                                  controller: _passwordEC,
                                  validator: Validatorless.multiple([
                                    Validatorless.required('Senha obrigatória'),
                                    Validatorless.min(6, 'A senha contem pelo menos 6 caracteres')
                                  ]),),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: (){
                                      if(_emailEC.text.isNotEmpty){
                                        context.read<LoginController>().forgotPassword(_emailEC.text);

                                      }else {
                                        _emailFocus.requestFocus();
                                        Messages.of(context).showError('Digite um email para recuperar a senha');
                                      }
                                      
                                      
                                    }, 
                                    child: const Text('Esqueceu sua senha?')),
                                    ElevatedButton(
                                    
                                      onPressed:(){
                                        final formvalid = _formKey.currentState?.validate() ?? false;
                                      if(formvalid){
                                        final email = _emailEC.text;
                                        final password = _passwordEC.text;
                                        context.read<LoginController>().login(email, password);
                                      }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        )
                                      ),
                                      child: const Padding(
                                        padding:  EdgeInsets.all(10.0),
                                        child: Text('Login'),
                                      ),)
                                  ],
                                )
                              ],
                            ),
                           ),
                         ),
                         const SizedBox(height: 20,),
                         Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color:const  Color(0xffF0f3f7),
                              border: Border(top: BorderSide(width: 2, color: Colors.grey.withAlpha(50)))
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),
                                SignInButton(
                                  Buttons.Google,                                   
                                  text: 'Continue com o Google',
                                  padding: const EdgeInsets.all(5),
                                  shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                  ),
                                  onPressed: (){
                                    context.read<LoginController>().googleLogin(); 
                                  }, 
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Não tem Conta?'),
                                      TextButton(onPressed: () {
                                        Navigator.of(context).pushNamed('/register');
                                      }, 
                                      child: const Text('Cadastre-se'))
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
       );
  }
} 