import 'package:monee/main_development.dart' as dev;
import 'package:monee/main_production.dart' as prod;
import 'package:monee/main_staging.dart' as staging;

Future<void> main() async {
  const flavor = String.fromEnvironment('FLAVOR');

  switch (flavor) {
    case 'development':
      await dev.main();
    case 'staging':
      await staging.main();
    case 'production':
      await prod.main();
    default:
      await dev.main(); // fallback
  }
}
