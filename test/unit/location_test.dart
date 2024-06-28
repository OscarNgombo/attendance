import 'package:attendance/controllers/geolocator/geolocator_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockLocationService extends Mock implements LocationService {}

@GenerateMocks([
  LocationService,
], customMocks: [
  MockSpec<LocationService>(
    as: #MockLocationService,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  late LocationService mockLocationService;

  setUp(() {
    mockLocationService = MockLocationService();
  });

  test("Test Location Service", () {
    expect(mockLocationService, isInstanceOf<LocationService>());
  });
}
