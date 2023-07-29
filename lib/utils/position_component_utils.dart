import 'package:flame/components.dart';
import 'package:flame/game.dart';

extension PositionComponentExtension on PositionComponent {
  double get cameraZoomLevel => (findGame()! as FlameGame).firstChild<CameraComponent>()!.viewfinder.zoom;
}
