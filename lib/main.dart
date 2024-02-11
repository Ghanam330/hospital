import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_router.dart';
import 'cubit/user_cubit/user_cubit.dart';
import 'utils/custom_theme.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.getInstance();
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}
class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserCubit(),
        child: BlocConsumer<UserCubit, UserState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              // return LayoutBuilder(
              //     builder: (context, constraints) {
              //       final customTheme = CustomTheme(constraints);
              //     return MaterialApp(
              //       debugShowCheckedModeBanner: false,
              //       theme: ThemeData(
              //         primarySwatch: Colors.blue,
              //         textTheme: customTheme.nunito(),
              //         elevatedButtonTheme: customTheme.elevatedButtonTheme(),
              //         outlinedButtonTheme: customTheme.outlinedButtonTheme(),
              //         textButtonTheme: customTheme.textButtonTheme(),
              //         dividerTheme: customTheme.dividerTheme(),
              //       ),
              //       onGenerateRoute: appRouter.generateRoute,
              //     );
              //   }
              // );
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                onGenerateRoute: appRouter.generateRoute,
              );
            })
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => AppProvider(),
//       child: LayoutBuilder(
//           builder: (context, constraints) {
//             final customTheme = CustomTheme(constraints);
//             return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData(
//                  primarySwatch: Colors.blue,
//                 textTheme: customTheme.nunito(),
//                 elevatedButtonTheme: customTheme.elevatedButtonTheme(),
//                 outlinedButtonTheme: customTheme.outlinedButtonTheme(),
//                 textButtonTheme: customTheme.textButtonTheme(),
//                 dividerTheme: customTheme.dividerTheme(),
//               ),
//               onGenerateRoute: appRouter.generateRoute,
//             );
//           }
//       ),
//     );
//   }
// }