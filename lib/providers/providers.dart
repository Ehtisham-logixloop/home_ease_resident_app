import 'package:provider/provider.dart';
import '../view_model/auth_view_model.dart';

final List<ChangeNotifierProvider> appProviders =[
  ChangeNotifierProvider<AuthViewModel>(
    create: (_) => AuthViewModel(),
  ),
];
