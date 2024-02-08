import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'utils/custom_theme.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}
class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: LayoutBuilder(
          builder: (context, constraints) {
            final customTheme = CustomTheme(constraints);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                 primarySwatch: Colors.blue,
                textTheme: customTheme.nunito(),
                elevatedButtonTheme: customTheme.elevatedButtonTheme(),
                outlinedButtonTheme: customTheme.outlinedButtonTheme(),
                textButtonTheme: customTheme.textButtonTheme(),
                dividerTheme: customTheme.dividerTheme(),
              ),
              onGenerateRoute: appRouter.generateRoute,
            );
          }
      ),
    );
  }
}