import 'dart:typed_data';

/// Packs JPEG frames into a short MP4 (Motion JPEG).
/// Android and iOS use a native H.264 encoder when it is available.
Uint8List muxMjpegMp4(
  List<Uint8List> jpegs, {
  required int width,
  required int height,
  int fps = 10,
}) {
  if (jpegs.isEmpty) {
    throw ArgumentError('A reel needs at least one frame');
  }
  final rate = fps.clamp(1, 60);
  final ftyp = _box(
    'ftyp',
    _concat([
      _ascii('isom'),
      _u32(0),
      _ascii('isom'),
      _ascii('iso2'),
      _ascii('mp41'),
    ]),
  );

  final sampleBytes = jpegs.fold<int>(0, (sum, frame) => sum + frame.length);
  final offsets = <int>[];
  var cursor = ftyp.length + 8;
  for (final frame in jpegs) {
    offsets.add(cursor);
    cursor += frame.length;
  }

  final moov = _moov(
    frameCount: jpegs.length,
    sizes: [for (final frame in jpegs) frame.length],
    offsets: offsets,
    width: width,
    height: height,
    fps: rate,
  );

  return _concat([
    ftyp,
    _box(
      'mdat',
      _concat(jpegs),
    ),
    moov,
  ]);
}

Uint8List _moov({
  required int frameCount,
  required List<int> sizes,
  required List<int> offsets,
  required int width,
  required int height,
  required int fps,
}) {
  final mvhd = _full(
    'mvhd',
    _concat([
      _u32(0),
      _u32(0),
      _u32(fps),
      _u32(frameCount),
      _u32(0x00010000),
      _u16(0x0100),
      _u16(0),
      _u32(0),
      _u32(0),
      _matrix(),
      _u32(0),
      _u32(0),
      _u32(0),
      _u32(0),
      _u32(0),
      _u32(0),
      _u32(2),
    ]),
  );
  final tkhd = _full(
    'tkhd',
    _concat([
      _u32(0),
      _u32(0),
      _u32(1),
      _u32(0),
      _u32(frameCount),
      _u32(0),
      _u32(0),
      _u16(0),
      _u16(0),
      _u16(0),
      _u16(0),
      _matrix(),
      _u32(width << 16),
      _u32(height << 16),
    ]),
    flags: 7,
  );
  final mdhd = _full(
    'mdhd',
    _concat([
      _u32(0),
      _u32(0),
      _u32(fps),
      _u32(frameCount),
      _u16(0x55c4),
      _u16(0),
    ]),
  );
  final hdlr = _full(
    'hdlr',
    _concat([
      _u32(0),
      _ascii('vide'),
      _u32(0),
      _u32(0),
      _u32(0),
      _ascii('VideoHandler\u0000'),
    ]),
  );
  final vmhd = _full(
    'vmhd',
    _concat([_u16(0), _u16(0), _u16(0), _u16(0)]),
    flags: 1,
  );
  final url = _full('url ', Uint8List(0), flags: 1);
  final dref = _full('dref', _concat([_u32(1), url]));
  final dinf = _box('dinf', dref);
  final stsd = _full('stsd', _concat([_u32(1), _jpegEntry(width, height)]));
  final stts = _full(
    'stts',
    _concat([_u32(1), _u32(frameCount), _u32(1)]),
  );
  final stscBody = BytesBuilder(copy: false)
    ..add(_u32(frameCount));
  for (var i = 0; i < frameCount; i++) {
    stscBody
      ..add(_u32(i + 1))
      ..add(_u32(1))
      ..add(_u32(1));
  }
  final stsc = _full('stsc', stscBody.toBytes());
  final stszBody = BytesBuilder(copy: false)
    ..add(_u32(0))
    ..add(_u32(frameCount));
  for (final size in sizes) {
    stszBody.add(_u32(size));
  }
  final stsz = _full('stsz', stszBody.toBytes());
  final stcoBody = BytesBuilder(copy: false)..add(_u32(frameCount));
  for (final offset in offsets) {
    stcoBody.add(_u32(offset));
  }
  final stco = _full('stco', stcoBody.toBytes());
  final stbl = _box('stbl', _concat([stsd, stts, stsc, stsz, stco]));
  final minf = _box('minf', _concat([vmhd, dinf, stbl]));
  final mdia = _box('mdia', _concat([mdhd, hdlr, minf]));
  final trak = _box('trak', _concat([tkhd, mdia]));
  return _box('moov', _concat([mvhd, trak]));
}

Uint8List _jpegEntry(int width, int height) {
  return _box(
    'jpeg',
    _concat([
      Uint8List(6),
      _u16(1),
      _u16(0),
      _u16(0),
      _u32(0),
      _u32(0),
      _u32(0),
      _u16(width),
      _u16(height),
      _u32(0x00480000),
      _u32(0x00480000),
      _u32(0),
      _u16(1),
      Uint8List(32),
      _u16(0x0018),
      _u16(0xffff),
    ]),
  );
}

Uint8List _box(String type, Uint8List payload) {
  final head = ByteData(8)..setUint32(0, 8 + payload.length);
  return _concat([head.buffer.asUint8List(), _ascii(type), payload]);
}

Uint8List _full(String type, Uint8List payload, {int flags = 0}) {
  final version = ByteData(4)..setUint32(0, flags & 0xffffff);
  return _box(type, _concat([version.buffer.asUint8List(), payload]));
}

Uint8List _u16(int value) {
  final data = ByteData(2)..setUint16(0, value & 0xffff);
  return data.buffer.asUint8List();
}

Uint8List _u32(int value) {
  final data = ByteData(4)..setUint32(0, value & 0xffffffff);
  return data.buffer.asUint8List();
}

Uint8List _ascii(String value) => Uint8List.fromList(value.codeUnits);

Uint8List _matrix() {
  return _concat([
    _u32(0x00010000),
    _u32(0),
    _u32(0),
    _u32(0),
    _u32(0x00010000),
    _u32(0),
    _u32(0),
    _u32(0),
    _u32(0x40000000),
  ]);
}

Uint8List _concat(List<Uint8List> parts) {
  final out = BytesBuilder(copy: false);
  for (final part in parts) {
    out.add(part);
  }
  return out.takeBytes();
}
