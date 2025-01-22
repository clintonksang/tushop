import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/web.dart';

import '../../presentation/widgets/custom_snackbar.dart';

noInternet() {
  final Connectivity connectivity = Connectivity();

  if (connectivity == ConnectivityResult.none) {
    Logger().i('No internet connection');
    CustomSnackbar(message: 'No internet connection');
    return true;
  } else {
    return false;
  }
}
