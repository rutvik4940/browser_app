import 'package:flutter/material.dart';
import 'package:mirror_well_app/screen/home/view/home_screen.dart';
import 'package:provider/provider.dart';

import 'screen/home/provider/home_provider.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value:HomeProvider()),
        ],
        child: Consumer<HomeProvider>(
          builder: (context, value, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              routes:{
                "/":(context) => HomeScreen(),
              }
            );
          },
        ),
      )
  );
}