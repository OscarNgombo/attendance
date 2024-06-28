import 'package:attendance/services/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockAuthMethods extends Mock implements AuthMethods {}

@GenerateMocks([
  AuthMethods,
], customMocks: [
  MockSpec<AuthMethods>(
    as: #MockAuthMethods,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  late AuthMethods mockAuthMethods;

  setUp(() {
    mockAuthMethods = MockAuthMethods();
  });

  test("Test Authentication Service", () {
    expect(mockAuthMethods, isInstanceOf<AuthMethods>());
  });
}
