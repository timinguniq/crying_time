import 'package:crying_time/domain/entity/device_registration.dart';
import 'package:crying_time/domain/repository/device_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

/// 앱이 뜰 때 기기를 서버에 등록한다.
class RegisterDevice implements UseCase<DeviceRegistration, NoParams> {
  const RegisterDevice(this._repository);

  final DeviceRepository _repository;

  @override
  Future<Result<DeviceRegistration>> call(NoParams params) =>
      _repository.registerDevice();
}
