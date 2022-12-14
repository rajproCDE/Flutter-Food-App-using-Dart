import 'dart:async';

import 'package:cache_manager/core/cache_manager_utils.dart';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pizzeria/app/constants/app.colors.dart';
import 'package:pizzeria/app/constants/app.keys.dart';
import 'package:pizzeria/app/routes/app.routes.dart';
import 'package:pizzeria/core/notifiers/themeNotifier/theme.notifier.dart';
import 'package:pizzeria/core/services/auth.service.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future initiateCache() async {
    CacheManagerUtils.conditionalCache(
      key: AppKeys.userEmail,
      valueType: ValueType.StringValue,
      actionIfNull: () {
        Navigator.of(context).pushNamed(AppRoutes.loginRoute);
      },
      actionIfNotNull: () async {
        String email = await ReadCache.getString(key: AppKeys.userEmail);
        String password = await ReadCache.getString(key: AppKeys.userPassword);

        Provider.of<AuthNotifier>(context, listen: false)
            .logIntoAccount(
          email: email,
          password: password,
        )
            .whenComplete(() {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homeRoute);
        });
      },
    );
  }

  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => initiateCache(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200.0,
            width: 400.0,
            child: Lottie.asset('assets/animation/pizza.json'),
          ),
          RichText(
            text: TextSpan(
              text: 'Good ',
              style: TextStyle(
                fontSize: 20.0,
                color: themeFlag ? Colors.white : AppColors.black,
              ),
              children: [
                TextSpan(
                  text: 'Health ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: themeFlag ? Colors.white : AppColors.black,
                  ),
                ),
                const TextSpan(
                  text: 'Good Food',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.red),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Powered ',
              style: TextStyle(
                fontSize: 10.0,
                color: themeFlag ? Colors.white : AppColors.black,
              ),
              children: [
                TextSpan(
                  text: 'By FoodLa',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: themeFlag ? Colors.white : AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
