import 'package:provider/provider.dart';
import '../view_model/theme_view_model.dart';
import '../view_model/message_view_model.dart';

final List<ChangeNotifierProvider> appProviders =[
  ChangeNotifierProvider<ThemeProvider>(
    create: (_) => ThemeProvider(),
  ),
  ChangeNotifierProvider<MessagesViewModel>(
    create: (_) => MessagesViewModel(),
  ),
];
