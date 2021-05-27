import 'dart:ffi' as ffi;
import 'dart:io' show Platform;
import 'package:path/path.dart' as path;

final DIR = path.dirname(Platform.script.toFilePath());

void main() {
  final so = path.join(DIR, 'so', 'blake3.so');
  final dylib = ffi.DynamicLibrary.open(so);
}
