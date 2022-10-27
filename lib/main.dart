import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:opennutritracker/core/data/data_source/intake_data_source.dart';
import 'package:opennutritracker/core/data/data_source/user_data_source.dart';
import 'package:opennutritracker/core/data/repository/intake_repository.dart';
import 'package:opennutritracker/core/data/repository/user_repository.dart';
import 'package:opennutritracker/core/presentation/main_screen.dart';
import 'package:opennutritracker/core/styles/color_schemes.dart';
import 'package:opennutritracker/core/styles/fonts.dart';
import 'package:opennutritracker/core/utils/hive_db_provider.dart';
import 'package:opennutritracker/core/utils/logger_config.dart';
import 'package:opennutritracker/core/utils/navigation_options.dart';
import 'package:opennutritracker/features/addItem/presentation/add_item_screen.dart';
import 'package:opennutritracker/features/scanner/scanner_screen.dart';
import 'package:opennutritracker/features/item_detail/item_detail_screen.dart';
import 'package:opennutritracker/features/settings/settings_screen.dart';
import 'package:opennutritracker/generated/l10n.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoggerConfig.intiLogger();
  final hiveDBProvider = HiveDBProvider();
  await hiveDBProvider.initHiveDB();
  final IntakeDataSource intakeDataSource =
      IntakeDataSource(hiveDBProvider.intakeBox);
  final UserDataSource userDataSource = UserDataSource(hiveDBProvider.userBox);

  final log = Logger('main');
  log.info('Starting App ...');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => hiveDBProvider),
    RepositoryProvider(create: (context) => IntakeRepository(intakeDataSource)),
    RepositoryProvider(create: (context) => UserRepository(userDataSource))
  ], child: const OpenNutriTrackerApp()));
}

class OpenNutriTrackerApp extends StatelessWidget {
  const OpenNutriTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: appTextTheme),
      // darkTheme: ThemeData(
      //     useMaterial3: true,
      //     colorScheme: darkColorScheme,
      //     textTheme: appTextTheme),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: NavigationOptions.mainRoute,
      routes: {
        NavigationOptions.mainRoute: (context) => const MainScreen(),
        NavigationOptions.settingsRoute: (context) => const SettingsScreen(),
        NavigationOptions.addItemRoute: (context) => const AddItemScreen(),
        NavigationOptions.scannerRoute: (context) => const ScannerScreen(),
        NavigationOptions.itemDetailRoute: (context) =>
            const ItemDetailScreen(),
      },
    );
  }
}
