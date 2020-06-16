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

    var input =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras orci ex, pellentesque quis lobortis in";
    var dyScroll = -100.0;
    final list = find.byValueKey("list");

    group('Encrypt and Decrypt', () {
      final parent = find.byValueKey("encrypt-decrypt");

      test('Encrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("encrypt"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("message")),
        );
        await driver.enterText(input);
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );

        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result != "", true);
      }, timeout: Timeout(Duration(minutes: 5)));

      test('Decrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("decrypt"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result, input);
      }, timeout: Timeout(Duration(minutes: 5)));
    });

    group('Encrypt and Decrypt Bytes', () {
      final parent = find.byValueKey("encrypt-decrypt-bytes");

      test('Encrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("encrypt"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("message")),
        );
        await driver.enterText(input);
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result != "", true);
      }, timeout: Timeout(Duration(minutes: 5)));

      test('Decrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("decrypt"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result, input);
      }, timeout: Timeout(Duration(minutes: 5)));
    });

    group('Encrypt and Decrypt Symmetric', () {
      final parent = find.byValueKey("encrypt-decrypt-symmetric");

      test('Encrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("encrypt"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("message")),
        );
        await driver.enterText(input);
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result != "", true);
      }, timeout: Timeout(Duration(minutes: 5)));

      test('Decrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("decrypt"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result, input);
      }, timeout: Timeout(Duration(minutes: 5)));
    });

    group('Encrypt and Decrypt Symmetric Bytes', () {
      final parent = find.byValueKey("encrypt-decrypt-symmetric-bytes");

      test('Encrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("encrypt"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("message")),
        );
        await driver.enterText(input);
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result != "", true);
      }, timeout: Timeout(Duration(minutes: 5)));

      test('Decrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("decrypt"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result, input);
      }, timeout: Timeout(Duration(minutes: 5)));
    });

    group('Sign And Verify', () {
      final parent = find.byValueKey("sign-verify");

      test('Sign', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("sign"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("message")),
        );
        await driver.enterText(input);
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result != "", true);
      }, timeout: Timeout(Duration(minutes: 5)));

      test('Verify', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("verify"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result, "VALID");
      }, timeout: Timeout(Duration(minutes: 5)));
    });

    group('Sign And Verify Bytes', () {
      final parent = find.byValueKey("sign-verify-bytes");

      test('Sign', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("sign"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("message")),
        );
        await driver.enterText(input);
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result != "", true);
      }, timeout: Timeout(Duration(minutes: 5)));

      test('Verify', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("verify"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result, "VALID");
      }, timeout: Timeout(Duration(minutes: 5)));

      test('Sign Bytes', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("sign-bytes"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("message")),
        );
        await driver.enterText(input);
        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(seconds: 60));
        var result = await driver.getText(resultSelector);
        expect(result != "", true);
      }, timeout: Timeout(Duration(minutes: 5)));
    });

    group('Generate', () {
      final parent = find.byValueKey("generate");

      test('Default', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("action"),
        );
        await driver.scrollUntilVisible(list, container, dyScroll: dyScroll);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var resultSelector =
            find.descendant(of: container, matching: find.byValueKey("result"));
        await driver.waitFor(resultSelector, timeout: Duration(minutes: 5));
        var result = await driver.getText(resultSelector);
        expect(result != "", true);
      }, timeout: Timeout(Duration(minutes: 5)));
    });
  });
}
