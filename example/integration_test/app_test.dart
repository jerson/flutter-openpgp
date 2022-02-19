import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openpgp_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('OpenPGP', () {
    var input =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras orci ex, pellentesque quis lobortis in";

    var dyScroll = 200.0;
    final list = find.byType(Scrollable).first;

    group('Encrypt and Decrypt', () {
      final parent = find.byKey(ValueKey("encrypt-decrypt"));

      testWidgets('Encrypt / Decrypt', (WidgetTester tester) async {
        final instance = app.MyApp();
        await tester.pumpWidget(instance);
        await tester.pumpAndSettle();

        var container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("encrypt")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.descendant(
                of: container, matching: find.byKey(ValueKey("message"))),
            input);
        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        var resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));

        await expectLater(resultSelector, findsWidgets);
        var result = resultSelector.evaluate().single.widget as Text;
        expect(result.data != "", equals(true));

        container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("decrypt")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        await expectLater(resultSelector, findsWidgets);

        result = resultSelector.evaluate().single.widget as Text;
        expect(result.data, equals(input));
      }, timeout: Timeout(Duration(seconds: 60)));
    });

    group('Encrypt and Decrypt Bytes', () {
      final parent = find.byKey(ValueKey("encrypt-decrypt-bytes"));

      testWidgets('Encrypt / Decrypt', (WidgetTester tester) async {
        final instance = app.MyApp();
        await tester.pumpWidget(instance);
        await tester.pumpAndSettle();

        var container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("encrypt")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.descendant(
                of: container, matching: find.byKey(ValueKey("message"))),
            input);
        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));

        var resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        var result = resultSelector.evaluate().single.widget as Text;
        expect(result.data != "", equals(true));

        container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("decrypt")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        result = resultSelector.evaluate().single.widget as Text;
        expect(result.data != "", equals(true));
      }, timeout: Timeout(Duration(seconds: 60)));
    });

    group('Encrypt and Decrypt Symmetric', () {
      final parent = find.byKey(ValueKey("encrypt-decrypt-symmetric"));

      testWidgets('Encrypt / Decrypt', (WidgetTester tester) async {
        final instance = app.MyApp();
        await tester.pumpWidget(instance);
        await tester.pumpAndSettle();

        var container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("encrypt")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.descendant(
                of: container, matching: find.byKey(ValueKey("message"))),
            input);
        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));

        var resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        var result = resultSelector.evaluate().single.widget as Text;
        expect(result.data != "", equals(true));

        container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("decrypt")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        result = resultSelector.evaluate().single.widget as Text;
        expect(result.data, equals(input));
      }, timeout: Timeout(Duration(seconds: 60)));
    });

    group('Encrypt and Decrypt Symmetric Bytes', () {
      final parent = find.byKey(ValueKey("encrypt-decrypt-symmetric-bytes"));

      testWidgets('Encrypt / Decrypt', (WidgetTester tester) async {
        final instance = app.MyApp();
        await tester.pumpWidget(instance);
        await tester.pumpAndSettle();

        var container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("encrypt")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.descendant(
                of: container, matching: find.byKey(ValueKey("message"))),
            input);
        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        var resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        var result = resultSelector.evaluate().single.widget as Text;
        expect(result.data != "", equals(true));

        container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("decrypt")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        result = resultSelector.evaluate().single.widget as Text;
        expect(result.data, equals(input));
      }, timeout: Timeout(Duration(seconds: 60)));
    });

    group('Sign And Verify', () {
      final parent = find.byKey(ValueKey("sign-verify"));

      testWidgets('Sign / Verify', (WidgetTester tester) async {
        final instance = app.MyApp();
        await tester.pumpWidget(instance);
        await tester.pumpAndSettle();

        var container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("sign")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.descendant(
                of: container, matching: find.byKey(ValueKey("message"))),
            input);
        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        var resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        var result = resultSelector.evaluate().single.widget as Text;
        expect(result.data != "", equals(true));

        container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("verify")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        result = resultSelector.evaluate().single.widget as Text;
        expect(result.data, "VALID");
      }, timeout: Timeout(Duration(seconds: 60)));
    });

    group('Sign And Verify Bytes', () {
      final parent = find.byKey(ValueKey("sign-verify-bytes"));

      testWidgets('Sign / Verify', (WidgetTester tester) async {
        final instance = app.MyApp();
        await tester.pumpWidget(instance);
        await tester.pumpAndSettle();

        var container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("sign")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.descendant(
                of: container, matching: find.byKey(ValueKey("message"))),
            input);
        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        var resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        var result = resultSelector.evaluate().single.widget as Text;
        expect(result.data != "", equals(true));

        container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("verify")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));
        resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        result = resultSelector.evaluate().single.widget as Text;
        expect(result.data, "VALID");
      }, timeout: Timeout(Duration(seconds: 60)));
    });

    group('Generate', () {
      final parent = find.byKey(ValueKey("generate"));

      testWidgets('Default', (WidgetTester tester) async {
        final instance = app.MyApp();
        await tester.pumpWidget(instance);
        await tester.pumpAndSettle();

        final container = find.descendant(
          of: parent,
          matching: find.byKey(ValueKey("action")),
        );
        await tester.scrollUntilVisible(container, dyScroll, scrollable: list);
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
              of: container, matching: find.byKey(ValueKey("button"))),
        );
        await tester.pumpAndSettle(Duration(seconds: 5));
        var resultSelector = find.descendant(
            of: container, matching: find.byKey(ValueKey("result")));
        expect(resultSelector, findsOneWidget);
        var result = resultSelector.evaluate().single.widget as Text;
        expect(result.data != "", equals(true));
      }, timeout: Timeout(Duration(minutes: 5)));
    });
  });
}
