import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/navigation/app_router.dart';
import '../../../../app/screens/main_screen_theme.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/utils/extensions/failure_extensions.dart';
import '../../../../app/widgets/app_button.dart';
import '../../../../app/widgets/app_text_field.dart';
import '../../../../injection_container.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    context.read<LoginCubit>().login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, Routes.inboxRoute);
          } else if (state is LoginFailure) {
            state.failure.showToast(context);
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return MainScreenTheme(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.translate('login'),
                    style: context.theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  AppTextField(
                    controller: _usernameController,
                    hintText: context.translate('username'),
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: _passwordController,
                    hintText: context.translate('password'),
                    isObsecureText: _obscurePassword,
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    onSubmitted: (_) => _submit(context),
                  ),
                  SizedBox(height: 24.h),
                  AppButton(
                    text: context.translate('login'),
                    isLoading: isLoading,
                    onClickEvent: isLoading ? null : () => _submit(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
