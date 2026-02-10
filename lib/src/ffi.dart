import 'package:universal_ffi/ffi.dart' as ffi;

import 'dart:io';

import 'dart:typed_data' as typed; // For Platform.isX
import 'package:universal_ffi/ffi.dart' as ffi;
import 'package:universal_ffi/ffi_utils.dart';

final ffi.DynamicLibrary bitmapFFILib = Platform.isAndroid
    ? ffi.DynamicLibrary.open("libbitmap.so")
    : ffi.DynamicLibrary.process();

typedef BitmapFFIExecution = void Function(
  ffi.Pointer<ffi.Uint8> startingPointer,
  typed.Uint8List pointerList,
);

class FFIImpl {
  FFIImpl(this.ffiExecution);

  final BitmapFFIExecution ffiExecution;

  void execute(typed.Uint8List sourceBmp) {
    final ffi.Pointer<ffi.Uint8> startingPointer = calloc<ffi.Uint8>(
      sourceBmp.length,
    );
    final pointerList = startingPointer.asTypedList(sourceBmp.length);
    pointerList.setAll(0, sourceBmp);
    ffiExecution(startingPointer, pointerList);
    sourceBmp.setAll(0, pointerList);

    calloc.free(startingPointer);
  }
}
