import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:one_debt/routes/routes.dart';

T getDependency<T extends Object>() => GetIt.I.get<T>();
Routes get routes => getDependency();
Logger get logger => getDependency();
Dio get dio => getDependency();
