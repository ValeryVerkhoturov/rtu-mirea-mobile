import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_block/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/forms/labelled_input.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogInSuccess) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text("Вход", style: DarkTextTheme.h4),
                const SizedBox(height: 13),
                RichText(
                  text: TextSpan(
                    text: 'Используйте ваши данные от  ',
                    style: DarkTextTheme.bodyRegular
                        .copyWith(color: DarkThemeColors.deactive),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'lk.mirea.ru', style: DarkTextTheme.bodyBold),
                      TextSpan(
                          text: "  для входа.",
                          style: DarkTextTheme.bodyRegular
                              .copyWith(color: DarkThemeColors.deactive)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                LabelledInput(
                    placeholder: "Email",
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    obscureText: obscureText,
                    label: "Ваш Email"),
                const SizedBox(height: 20),
                LabelledInput(
                    placeholder: "Пароль",
                    keyboardType: TextInputType.text,
                    controller: _passController,
                    obscureText: obscureText,
                    label: "Ваш пароль"),
                BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                  if (state is LogInError) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        state.cause,
                        style: DarkTextTheme.bodyRegular
                            .copyWith(color: DarkThemeColors.colorful07),
                      ),
                    );
                  }
                  return Container();
                }),
                const SizedBox(height: 40),
                PrimaryButton(
                  text: 'Войти',
                  onClick: () {
                    context.read<AuthBloc>().add(AuthLogInEvent(
                        login: _emailController.text,
                        password: _passController.text));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
