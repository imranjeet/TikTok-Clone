import 'package:agni_app/services/stoppable_service.dart';

class LocationService extends StoppableService {
  @override
  void start() {
    super.start();
    print('LocationService Started $serviceStopped');
  }

  @override
  void stop() {
    super.stop();
    print('LocationService Stopped $serviceStopped');
  }
}