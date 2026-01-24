import 'package:monee/app/app.dart';
import 'package:monee/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
