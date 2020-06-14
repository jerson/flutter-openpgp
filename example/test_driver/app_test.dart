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

    group('Encrypt and Decrypt', () {
      final parent = find.byValueKey("encrypt-decrypt");

      test('Encrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("encrypt"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

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
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var result = await driver.getText(
          find.descendant(of: container, matching: find.byValueKey("result")),
        );
        expect(result, input);
      });
    });

    group('Encrypt and Decrypt Bytes', () {
      final parent = find.byValueKey("encrypt-decrypt-bytes");

      test('Encrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("encrypt"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

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
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var result = await driver.getText(
          find.descendant(of: container, matching: find.byValueKey("result")),
        );
        expect(result, input);
      });
    });

    group('Encrypt and Decrypt Symmetric', () {
      final parent = find.byValueKey("encrypt-decrypt-symmetric");

      test('Encrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("encrypt"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

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
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var result = await driver.getText(
          find.descendant(of: container, matching: find.byValueKey("result")),
        );
        expect(result, input);
      });
    });

    group('Encrypt and Decrypt Symmetric Bytes', () {
      final parent = find.byValueKey("encrypt-decrypt-symmetric-bytes");

      test('Encrypt', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("encrypt"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

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
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var result = await driver.getText(
          find.descendant(of: container, matching: find.byValueKey("result")),
        );
        expect(result, input);
      });
    });

    group('Sign And Verify', () {
      final parent = find.byValueKey("sign-verify");

      test('Sign', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("sign"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

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

      test('Verify', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("verify"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var result = await driver.getText(
          find.descendant(of: container, matching: find.byValueKey("result")),
        );
        expect(result, "VALID");
      });
    });

    group('Sign And Verify Bytes', () {
      final parent = find.byValueKey("sign-verify-bytes");

      test('Sign', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("sign"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

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

      test('Verify', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("verify"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        var result = await driver.getText(
          find.descendant(of: container, matching: find.byValueKey("result")),
        );
        expect(result, "VALID");
      });

      test('Sign Bytes', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("sign-bytes"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

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
    });

    group('Generate', () {
      final parent = find.byValueKey("generate");

      test('Default', () async {
        final container = find.descendant(
          of: parent,
          matching: find.byValueKey("generate"),
        );
        await driver.waitFor(container);
        await driver.scrollIntoView(container);

        await driver.tap(
          find.descendant(of: container, matching: find.byValueKey("button")),
        );
        // maybe use a better delay or wait for condition
        await Future.delayed(Duration(seconds: 6));
        var result = await driver.getText(
          find.descendant(of: container, matching: find.byValueKey("result")),
        );
        expect(result != "", true);
      }, retry: 3, timeout: Timeout(Duration(minutes: 5)));
    });
  });
}
