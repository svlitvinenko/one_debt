import 'package:get_it/get_it.dart';
import 'package:one_debt/routes/routes.dart';

T getDependency<T extends Object>() => GetIt.I.get<T>();
Routes get routes => getDependency();
