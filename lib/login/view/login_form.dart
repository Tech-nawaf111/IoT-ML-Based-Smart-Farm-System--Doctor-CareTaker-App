import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp/login/login.dart';
import 'package:fyp/sign_up/sign_up.dart';

import 'package:formz/formz.dart';

import '../../animation/FadeAnimation.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {},
      child: Expanded(
        flex:1,
           child: Container(
             width: double.infinity,
             decoration: BoxDecoration(
                 gradient: LinearGradient(
                     begin: Alignment.topCenter,
                     colors: [
                       Color(0xFF37acfd),
                       Color(0xFF54fccb),
                     ]
                 )
             ),
             child: Column(

               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 SizedBox(height: 80,),
                 Padding(
                   padding: EdgeInsets.all(20),
                   child:
                   Row(children:[
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         FadeAnimation(1, Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),)),
                         SizedBox(height: 10,),
                         FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                       ],
                     ),
                     SizedBox(width: 100),
                     Container(
                       width: 150,
                       height: 150,
                       child:
                       Image.asset('assets/images/logo_main.png'),
                     )
                   ]),

                 ),
                 SizedBox(height: 20),
                 Expanded(
                   child: Container(
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                     ),
                     child: SingleChildScrollView(
                       child: Padding(
                         padding: EdgeInsets.all(30),
                         child: Column(
                           children: <Widget>[
                             SizedBox(height: 80,),
                             FadeAnimation(1.4, Container(
                               decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.circular(10),
                                   boxShadow: [BoxShadow(
                                       color: Color.fromRGBO(225, 95, 27, .3),
                                       blurRadius: 20,
                                       offset: Offset(0, 10)
                                   )]
                               ),
                               child: Column(
                                 children: <Widget>[
                                        const SizedBox(height: 8),
                                         _EmailInput(),
                                         const SizedBox(height: 20),
                                         _PasswordInput(),
                                   const SizedBox(height: 8),
                                 ],
                               ),
                             )),
                             SizedBox(height: 60,),
                           _LoginButton(),

                             SizedBox(height: 50,),
                             _SignUpButton(),
                             SizedBox(height: 30,),

                           ],
                         ),
                       ),
                     ),
                   ),
                 )
               ],
             ),
           ),
         )
      );
  }
}

class _EmailInput extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,

      builder: (context, state) {
       FocusNode myFocusNode = new FocusNode();
        return TextFormField(

          key: const Key('loginForm_emailInput_textField'),

          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            labelStyle: TextStyle(
                color: myFocusNode.hasFocus ? Color(0xFF37acfd) : Color(0xFF37acfd),

            ),
            prefixIcon: Icon(Icons.email, color: Color(0xFF37acfd),),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Color(0xFF37acfd), width: 2),

            ),
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {

        FocusNode myFocusNode = new FocusNode();
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
              labelStyle: TextStyle(
                color: myFocusNode.hasFocus ? Color(0xFF37acfd) : Color(0xFF37acfd),

              ),
            prefixIcon: Icon(Icons.lock, color: Color(0xFF37acfd),),

border: OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color:Color(0xFF37acfd), width: 2),

),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color:Color(0xFF37acfd), width: 2),

            ),

            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Container(
            decoration: BoxDecoration(

                borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xFF37acfd),
            ),
            height: 50,
           width: 400,

           child:  ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(

                  primary: const Color(0xFF37acfd),
                ),

                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().logInWithCredentials(context)
                    : null,
                child: const Text('LOGIN',style: TextStyle(color: Colors.white),),
              )
            );
      },
    );
  }


}



class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: const Text(
        'Dont have an Account? Register',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
