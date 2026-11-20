import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lifeverse_ai/core/network/api_client.dart';

void main() {
  test(
    'transport attaches the current token and never follows redirects',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final received = <String?>[];
      var redirected = false;
      server.listen((request) async {
        received.add(request.headers.value(HttpHeaders.authorizationHeader));
        if (request.uri.path == '/redirect') {
          request.response.statusCode = 302;
          request.response.headers.set(
            HttpHeaders.locationHeader,
            '/should-not-follow',
          );
        } else {
          if (request.uri.path == '/should-not-follow') redirected = true;
          request.response.headers.contentType = ContentType.json;
          request.response.write(jsonEncode({'ok': true}));
        }
        await request.response.close();
      });
      final auth = SupabaseClient(
        'https://test.supabase.co',
        'public-test',
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      );
      final api = ApiClient('http://127.0.0.1:${server.port}', auth);
      addTearDown(() async {
        api.dispose();
        await auth.dispose();
        await server.close(force: true);
      });
      Future<void> restore(String value) => auth.auth.recoverSession(
        jsonEncode({
          'access_token': value,
          'token_type': 'bearer',
          'refresh_token': 'test-refresh',
          'expires_at':
              DateTime.now()
                  .add(const Duration(hours: 1))
                  .millisecondsSinceEpoch ~/
              1000,
          'user': {
            'id': 'test-owner',
            'aud': 'authenticated',
            'app_metadata': {},
            'user_metadata': {},
            'created_at': '2026-11-20T00:00:00Z',
          },
        }),
      );
      await restore('test-token-one');
      expect(await api.request('/ok'), {'ok': true});
      await restore('test-token-two');
      await api.request('/ok');
      expect(received, ['Bearer test-token-one', 'Bearer test-token-two']);
      await expectLater(api.request('/redirect'), throwsA(isA<ApiFailure>()));
      expect(redirected, false);
      for (final path in [
        'https://attacker.example',
        '//attacker.example',
        '/\\attacker.example',
      ]) {
        await expectLater(api.request(path), throwsA(isA<ApiFailure>()));
      }
      expect(received.length, 3);
    },
  );
}
