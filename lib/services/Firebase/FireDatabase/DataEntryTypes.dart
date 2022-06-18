class DatabasePosition {
  const DatabasePosition({required this.lat, required this.lon});
  final double lat, lon;

  Map<String, double> toJson() {
    return {"lat": lat, "lon": lon};
  }
}

class MPU {
  const MPU({required this.x, required this.y, required this.z});
  final double x, y, z;

  Map<String, double> toJson() {
    return {"x": x, "y": y, "z": z};
  }
}
