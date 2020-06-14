import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('OpenPGP', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    var input = "sample1111";

    group('Encrypt and Decrypt', ()  {
      final parent = find.byValueKey("encrypt-decrypt");

      test('Encrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("encrypt"),
        );
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("message")),
        );
        await driver.enterText(input);
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var result = await driver.getText(
          find.descendant(of: container, matching: find.byValueKey("result")),
        );
        expect(result != "", true);
      });

      test('Decrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("decrypt"),
        );
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var result = await driver.getText(
          find.descendant(of: container, matching: find.byValueKey("result")),
        );
        expect(result, input);
      });
    });

  });
}
