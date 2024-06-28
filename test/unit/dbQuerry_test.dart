import 'package:attendance/controllers/data/db_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockDbData extends Mock implements DbData {}

@GenerateMocks([
  DbData
], customMocks: [
  MockSpec<DbData>(
    as: #MockDbData,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  late DbData mockDbData;

  setUp(() {
    mockDbData = MockDbData();
  });

  test("Test Location Service", () {
    expect(mockDbData, isInstanceOf<MockDbData>());
  });
}
