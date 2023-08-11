// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todolist_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todolist_provider/app/core/ui/messages.dart';

class DefaultListenerNotifier {
final  DefaultChangeNotifier changeNotifier;
 


  DefaultListenerNotifier({
    required this.changeNotifier,
  });

  void listener ({ 
    required BuildContext context,
    required SuccessVoidCallBack successVoidCallBack,
    ErrorVoidCallBack? errorVoidCallBack,
    EverVoidCallBack? everVoidCallBack
    }){
    changeNotifier.addListener(() {
      if(everVoidCallBack != null){
        everVoidCallBack(changeNotifier, this);
      }

      if(changeNotifier.loading){
        Loader.show(context);
      } else {
        Loader.hide();
      }

      if(changeNotifier.hasError){
        if(errorVoidCallBack != null){
          errorVoidCallBack(changeNotifier, this);
        }
        Messages.of(context).showError(changeNotifier.error ?? 'Erro Interno');
      }else if (changeNotifier.isSucess){
          successVoidCallBack(changeNotifier, this);       
      }
    });
  }
  void dispose(){
    changeNotifier.removeListener(() { });
    

  }
}

typedef SuccessVoidCallBack = void Function (
  DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance
);

typedef ErrorVoidCallBack = void Function (
  DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance
);

typedef EverVoidCallBack = void Function (
  DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance
);
