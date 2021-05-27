import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import './c/blake3.dart';
import 'dart:ffi';
import 'dart:convert' show utf8;
import 'package:ffi/ffi.dart' as ffi;

const allocate = ffi.malloc;
final DIR = path.dirname(Platform.script.toFilePath());

extension Uint8ListPointer on Uint8List {
  // https://github.com/dart-lang/ffi/issues/31
  // Workaround: before does not allow direct pointer exposure
  Pointer ptr() {
    final ptr = allocate<Uint8>(length);
    final typedList = ptr.asTypedList(length);
    typedList.setAll(0, this);
    return ptr;
  }
}

void main() {
  final so = path.join(DIR, 'so', 'blake3.so');
  final dylib = DynamicLibrary.open(so);
  final lib = cBlake3(dylib);

  final hasher = allocate<blake3_hasher>();

  final data = utf8.encoder.convert("123");
  lib.blake3_hasher_init(hasher);
  lib.blake3_hasher_update(hasher, data.ptr().cast(), data.length);

  final out = Uint8List(BLAKE3_OUT_LEN);
  lib.blake3_hasher_finalize(hasher, out.ptr().cast(), BLAKE3_OUT_LEN);
  print(out);
}
