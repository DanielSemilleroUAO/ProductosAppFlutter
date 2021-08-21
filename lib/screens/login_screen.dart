import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/services/notifications_service.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ChangeNotifierProvider(
                        create: (_) => LoginFormProvider(), child: _LoginForm())
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Colors.indigo.withOpacity(0.1),
                    ),
                    shape: MaterialStateProperty.all(StadiumBorder())),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'register'),
                child: Text(
                  'Crear una nueva cuenta',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'daniel@gmail.com',
                    labelText: 'Correo electrónico',
                    iconData: Icons.alternate_email_rounded),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingresado no es el correcto';
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '****',
                    labelText: 'Contraseña',
                    iconData: Icons.lock_outline),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  if (value != null && value.length >= 6) {
                    return null;
                  }
                  return 'La contraseña debe se de 6 caracteres';
                },
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.deepPurple,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Espere...' : 'Ingresar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          if (!loginForm.isValidForm()) {
                            return;
                          }
                          loginForm.setLoading = true;

                          final String? errorMessage = await authService.login(
                              loginForm.email, loginForm.password);
                          print(errorMessage);
                          if (errorMessage == null) {
                            Navigator.pushReplacementNamed(context, 'home');
                          } else {
                            print(errorMessage);
                            NotificationService.showSnackvar(errorMessage);
                            loginForm.setLoading = false;
                          }
                        })
            ],
          )),
    );
  }
}