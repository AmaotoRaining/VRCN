import 'package:flutter/foundation.dart';

@immutable
class DeviceInfo {
  final String name;
  final String ip;
  final int port;
  final String type;

  const DeviceInfo({
    required this.name,
    required this.ip,
    required this.port,
    required this.type,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      name: json['name'] ?? '',
      ip: json['ip'] ?? '',
      port: json['port'] ?? 0,
      type: json['type'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'ip': ip, 'port': port, 'type': type};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceInfo &&
        other.name == name &&
        other.ip == ip &&
        other.port == port &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(name, ip, port, type);
}

@immutable
class SyncStatus {
  final bool isServerRunning;
  final bool isScanning;
  final List<DeviceInfo> devices;
  final String? errorMessage;
  final String? serverIP;
  final int? serverPort;
  final int receivedPhotosCount; // 受信した写真数
  final DateTime? lastReceived; // 最後に受信した時刻

  const SyncStatus({
    this.isServerRunning = false,
    this.isScanning = false,
    this.devices = const [],
    this.errorMessage,
    this.serverIP,
    this.serverPort,
    this.receivedPhotosCount = 0,
    this.lastReceived,
  });

  SyncStatus copyWith({
    bool? isServerRunning,
    bool? isScanning,
    List<DeviceInfo>? devices,
    String? errorMessage,
    String? serverIP,
    int? serverPort,
    int? receivedPhotosCount,
    DateTime? lastReceived,
  }) {
    return SyncStatus(
      isServerRunning: isServerRunning ?? this.isServerRunning,
      isScanning: isScanning ?? this.isScanning,
      devices: devices ?? this.devices,
      errorMessage: errorMessage,
      serverIP: serverIP ?? this.serverIP,
      serverPort: serverPort ?? this.serverPort,
      receivedPhotosCount: receivedPhotosCount ?? this.receivedPhotosCount,
      lastReceived: lastReceived ?? this.lastReceived,
    );
  }
}
