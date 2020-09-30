import 'package:boots/helper/api.dart';
import 'package:boots/model/CrudModel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => Api('communities'));
  locator.registerLazySingleton(() => CRUDModel()) ;
}