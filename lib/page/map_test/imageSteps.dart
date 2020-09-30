String getImageSteps(var steps) {
  switch (steps) {
    case "turn-left":
      return 'assets/images/directions/left.png';
      break;
    case "turn-slight-left":
      return 'assets/images/directions/slightly_left.png';
      break;
    case "turn-sharp-left":
      return 'assets/images/directions/hard_left.png';
      break;
    case "uturn-left":
      return 'assets/images/directions/uturn_left.png';
      break;
    case "turn-slight-right":
      return 'assets/images/directions/slightly_right.png';
      break;
    case "turn-sharp-right":
      return 'assets/images/directions/hard_right.png';
      break;
    case "uturn-right":
      return 'assets/images/directions/uturn_right.png';
      break;
    case "turn-right":
      return 'assets/images/directions/right.png';
      break;
    case "straight":
      return 'assets/images/directions/continue.png';
      break;
    case "ramp-left":
      return 'assets/images/directions/ramp-left.png';
      break;
    case "ramp-right":
      return 'assets/images/directions/ramp-right.png';
      break;
    case "merge":
      return 'assets/images/directions/merge.png';
      break;
    case "fork-left":
      return 'assets/images/directions/fork-left.png';
      break;
    case "fork-right":
      return 'assets/images/directions/fork-right.png';
      break;
    case "roundabout-left":
      return 'assets/images/directions/roundabout-left.png';
      break;
    case "roundabout-right":
      return 'assets/images/directions/fork-right.png';
      break;
    case "roundabout-right":
      return 'assets/images/directions/roundabout-right.png';
      break;
    default:
      return "assets/images/directions/map-marker.png";
      break;
  }
}
