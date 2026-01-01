import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:bdf_school/pages/tugas/tugas_page.dart';
import 'package:bdf_school/state/auth_controller.dart';
import 'package:bdf_school/utils/api_client.dart';

class FakeAuthController extends AuthController {
  FakeAuthController() : super(baseUrl: '');

  @override
  Future<bool> checkAuthStatus() async => true;

  @override
  String? get token => 'fake-token';
}

class FakeApiClient extends ApiClient {
  FakeApiClient(this.controller)
      : super(
          controller,
          baseUrl: '',
          client: _FakeHttpClient(),
        );

  final FakeAuthController controller;
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'judul': 'Matematika',
      'deskripsi': 'Aljabar linear',
      'guru': 'Bu Ani',
      'kelas': 'Kelas 10',
      'deadline': '2025-01-31',
      'success': true,
    },
    {
      'id': '2',
      'judul': 'Biologi',
      'deskripsi': 'Sel dan jaringan',
      'guru': 'Pak Budi',
      'kelas': 'Kelas 11',
      'deadline': '2025-02-10',
      'success': true,
    },
  ];

  @override
  Future<http.Response> get(String path) async {
    return http.Response(jsonEncode({'success': true, 'data': _tasks}), 200);
  }

  @override
  Future<http.Response> post(String path, {Object? body}) async {
    if (body is Map) {
      final newId = (_tasks.length + 1).toString();
      _tasks.add({
        'id': newId,
        'judul': body['judul'],
        'deskripsi': body['deskripsi'] ?? '',
        'guru': body['guru'] ?? '',
        'kelas': body['kelas'] ?? '',
        'deadline': body['deadline'] ?? '',
        'success': true,
      });
    }
    return http.Response(jsonEncode({'success': true}), 201);
  }
}

class _FakeHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(Stream<List<int>>.value(const []), 200);
  }
}

Widget _wrapWithProviders(Widget child, FakeAuthController controller) {
  return MaterialApp(
    home: ChangeNotifierProvider<AuthController>.value(
      value: controller,
      child: child,
    ),
  );
}

void main() {
  testWidgets('Pencarian tugas memfilter list berdasarkan keyword', (tester) async {
    final auth = FakeAuthController();
    final api = FakeApiClient(auth);

    await tester.pumpWidget(
      _wrapWithProviders(TugasPage(api: api), auth),
    );

    // initial load
    await tester.pumpAndSettle();
    expect(find.text('Matematika'), findsOneWidget);
    expect(find.text('Biologi'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'bio');
    await tester.pumpAndSettle();

    expect(find.text('Biologi'), findsOneWidget);
    expect(find.text('Matematika'), findsNothing);
  });

  testWidgets('Tambah tugas menambah item dan tampil setelah refresh', (tester) async {
    final auth = FakeAuthController();
    final api = FakeApiClient(auth);

    await tester.pumpWidget(
      _wrapWithProviders(TugasPage(api: api, allowManualDeadlineEntry: true), auth),
    );

    // initial load
    await tester.pumpAndSettle();
    expect(find.text('Matematika'), findsOneWidget);

    await tester.tap(find.text('Tambah Tugas'));
    await tester.pumpAndSettle();

    final dialog = find.byType(Dialog);
    final dialogTextFields = find.descendant(of: dialog, matching: find.byType(TextField));

    await tester.enterText(dialogTextFields.at(0), 'Fisika');
    await tester.enterText(dialogTextFields.at(1), 'Gerak lurus');

    final kelasDropdown = find.descendant(of: dialog, matching: find.byType(DropdownButtonFormField<String>));
    await tester.tap(kelasDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kelas 10').last);
    await tester.pumpAndSettle();

    await tester.enterText(dialogTextFields.at(2), 'Pak Andi');
    await tester.enterText(dialogTextFields.at(3), '2025-03-01');

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // After post, fetchTasks is called; pump to let it rebuild.
    await tester.pumpAndSettle();
    expect(find.text('Fisika'), findsOneWidget);
  });
}
