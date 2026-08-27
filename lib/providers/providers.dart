import 'package:provider/provider.dart';
import '../view_model/theme_view_model.dart';

final List<ChangeNotifierProvider> appProviders =[
  ChangeNotifierProvider<ThemeProvider>(
    create: (_) => ThemeProvider(),
  ),
];
