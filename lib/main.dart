import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/app/di/service_locator.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/product/presentation/pages/product_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ServiceLocator.createProductBloc(),
        ),
        BlocProvider(
          create: (_) => ServiceLocator.createCartBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'SmartCart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const ProductListPage(),
      ),
    );
  }
}
