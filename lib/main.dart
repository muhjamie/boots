import 'package:boots/blocs/place_bloc.dart';
import 'package:boots/helper/locator.dart';
import 'package:boots/state/communitiesState.dart';
import 'package:boots/state/mapState.dart';
import 'package:flutter/material.dart';
import 'package:boots/helper/theme.dart';
import 'package:boots/state/searchState.dart';
import 'package:boots/state/nearbyState.dart';
import 'package:flutter/services.dart';
import 'helper/routes.dart';
import 'state/appState.dart';
import 'package:provider/provider.dart';
import 'state/authState.dart';
import 'state/chats/chatState.dart';
import 'state/feedState.dart';
import 'package:google_fonts/google_fonts.dart';
import 'state/notificationState.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColor.primary
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
        ChangeNotifierProvider<ChatState>(create: (_) => ChatState()),
        ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),
        ChangeNotifierProvider<NotificationState>(create: (_) => NotificationState()),
        ChangeNotifierProvider<MapState>(create: (_) => MapState()),
        ChangeNotifierProvider<CommunitiesState>(create: (_) => CommunitiesState()),
        ChangeNotifierProvider<NearbyState>(create: (_) => NearbyState()),
        ChangeNotifierProvider<PlaceBloc>(create: (_) => PlaceBloc()),
      ],
      child: MaterialApp(
        title: 'Boots',
        theme: AppTheme.apptheme.copyWith(
          textTheme: GoogleFonts.muliTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
      ),
    );
  }
}
