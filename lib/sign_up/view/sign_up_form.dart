import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp/sign_up/sign_up.dart';
import 'package:formz/formz.dart';

import '../../animation/FadeAnimation.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
    child: Align(
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
                    FadeAnimation(1, Text("Register an", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, fontFamily:"Raleway"),)),
                    SizedBox(height: 10,),
                    FadeAnimation(1.3, Text("Account", style: TextStyle(color: Colors.white, fontSize: 28,fontWeight: FontWeight.bold, ),)),
                  ],
                ),
                SizedBox(width: 10),
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
                              const SizedBox(height: 5),
                              _EmailInput(),
                              const SizedBox(height: 5),
                              _PasswordInput(),
                              const SizedBox(height: 5),
                              _ConfirmPasswordInput(),
                            ],
                          ),
                        )),
                        SizedBox(height: 20),
                        _SignUpButton(),

                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        FocusNode myFocusNode = new FocusNode();
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: myFocusNode.hasFocus ? Color(0xFF37acfd) : Color(0xFF37acfd),

            ),
            prefixIcon: Icon(Icons.email, color: Color(0xFF37acfd),),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Color(0xFF37acfd), width: 2),

            ),
            labelText: 'email',
            helperText: '',
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        FocusNode myFocusNode = new FocusNode();
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: myFocusNode.hasFocus ? Color(0xFF37acfd) : Color(0xFF37acfd),

            ),
            prefixIcon: Icon(Icons.lock, color: Color(0xFF37acfd),),


            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.brown, width: 2),

            ),
            labelText: 'password',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        FocusNode myFocusNode = new FocusNode();
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmPassword) => context
              .read<SignUpCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(

              color: myFocusNode.hasFocus ? Color(0xFF37acfd) : Color(0xFF37acfd),

            ),
            prefixIcon: Icon(Icons.lock, color:Color(0xFF37acfd),),


            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Color(0xFF37acfd), width: 2),

            ),
            labelText: 'confirm password',
            helperText: '',
            errorText: state.confirmedPassword.invalid
                ? 'passwords do not match'
                : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Container(
          decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0xFF37acfd) ,
          ),
          height: 50,
          width: 400,
          child:
            ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
              style: ElevatedButton.styleFrom(

                primary: const Color(0xFF37acfd),
              ),
                onPressed: state.status.isValidated
                    ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                    : null,
                child: const Text('SIGN UP', style: TextStyle(color: Colors.white),),
              ),);
      },
    );
  }
}
