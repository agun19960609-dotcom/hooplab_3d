import 'dart:convert';

/// Coach diagrams stored in the app schema, including full-court sets that
/// the half-court canvas cannot represent.
String courtPlay(String name, List<List<Map<String, dynamic>>> frames) {
  return jsonEncode({
    'playName': name,
    'steps': [
      for (var i = 0; i < frames.length; i++)
        {'phaseId': i, 'actions': frames[i]},
    ],
  });
}

Map<String, dynamic> act(
  int id,
  String type,
  List<List<double>> path, [
  int? target,
]) {
  return {
    'playerId': id,
    'actionType': type,
    'path': path,
    if (target != null) 'targetPlayerId': target,
  };
}

List<double> at(double x, double y) => [x, y];

List<Map<String, dynamic>> hold(int carrier, List<double> spot, List<Map<String, dynamic>> others) {
  return [
    ...others,
    act(carrier, 'dribble', [spot], carrier),
  ];
}

final Map<String, String> extraPlayJson = {
  'half-11': courtPlay('Horns Twist', [
    hold(1, at(0.50, 0.40), [
      act(1, 'run', [at(0.50, 0.40), at(0.58, 0.32)]),
      act(4, 'screen', [at(0.36, 0.24), at(0.46, 0.30)]),
      act(5, 'screen', [at(0.64, 0.24), at(0.70, 0.30)]),
      act(2, 'run', [at(0.86, 0.16), at(0.78, 0.30)]),
      act(3, 'run', [at(0.14, 0.28)]),
    ]),
    hold(2, at(0.78, 0.30), [
      act(1, 'pass', [at(0.58, 0.32), at(0.78, 0.30)], 2),
      act(2, 'shoot', [at(0.78, 0.30), at(0.50, 0.08)]),
      act(4, 'run', [at(0.46, 0.30), at(0.42, 0.16)]),
      act(5, 'run', [at(0.70, 0.30), at(0.62, 0.14)]),
      act(3, 'run', [at(0.14, 0.28), at(0.20, 0.16)]),
    ]),
  ]),
  'half-12': courtPlay('Wing Pick & Roll', [
    hold(1, at(0.22, 0.32), [
      act(1, 'run', [at(0.22, 0.32), at(0.34, 0.26)]),
      act(5, 'screen', [at(0.30, 0.22), at(0.40, 0.26)]),
      act(2, 'run', [at(0.84, 0.30), at(0.88, 0.18)]),
      act(3, 'run', [at(0.14, 0.16)]),
      act(4, 'run', [at(0.62, 0.20), at(0.70, 0.16)]),
    ]),
    hold(1, at(0.34, 0.26), [
      act(1, 'pass', [at(0.34, 0.26), at(0.48, 0.14)], 5),
      act(5, 'run', [at(0.40, 0.26), at(0.48, 0.14)]),
      act(5, 'shoot', [at(0.48, 0.14), at(0.50, 0.08)]),
      act(2, 'run', [at(0.88, 0.18)]),
      act(3, 'run', [at(0.14, 0.16), at(0.18, 0.28)]),
      act(4, 'run', [at(0.70, 0.16), at(0.74, 0.28)]),
    ]),
  ]),
  'half-13': courtPlay('UCLA Cut', [
    hold(1, at(0.50, 0.38), [
      act(1, 'run', [at(0.50, 0.38)]),
      act(5, 'screen', [at(0.42, 0.20), at(0.50, 0.24)]),
      act(2, 'run', [at(0.78, 0.30), at(0.52, 0.16)]),
      act(3, 'run', [at(0.16, 0.30), at(0.22, 0.18)]),
      act(4, 'run', [at(0.66, 0.22)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.38), at(0.52, 0.16)], 2),
      act(2, 'shoot', [at(0.52, 0.16), at(0.50, 0.08)]),
      act(5, 'run', [at(0.50, 0.24), at(0.38, 0.16)]),
      act(3, 'run', [at(0.22, 0.18)]),
      act(4, 'run', [at(0.66, 0.22), at(0.80, 0.20)]),
      act(1, 'dribble', [at(0.50, 0.38)], 1),
    ],
  ]),
  'half-14': courtPlay('Pin Down', [
    hold(1, at(0.50, 0.36), [
      act(1, 'run', [at(0.50, 0.36)]),
      act(4, 'screen', [at(0.70, 0.16), at(0.78, 0.24)]),
      act(2, 'run', [at(0.86, 0.12), at(0.82, 0.30)]),
      act(5, 'run', [at(0.38, 0.18), at(0.34, 0.28)]),
      act(3, 'run', [at(0.16, 0.28)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.36), at(0.82, 0.30)], 2),
      act(2, 'shoot', [at(0.82, 0.30), at(0.50, 0.08)]),
      act(4, 'run', [at(0.78, 0.24), at(0.62, 0.14)]),
      act(5, 'run', [at(0.34, 0.28)]),
      act(3, 'run', [at(0.16, 0.28), at(0.14, 0.16)]),
      act(1, 'dribble', [at(0.50, 0.36)], 1),
    ],
  ]),
  'fast-01': courtPlay('Two-Man Break', [
    hold(1, at(0.42, 0.86), [
      act(1, 'run', [at(0.42, 0.86), at(0.48, 0.55)]),
      act(2, 'run', [at(0.70, 0.82), at(0.78, 0.28)]),
      act(3, 'run', [at(0.22, 0.84), at(0.18, 0.40)]),
      act(4, 'run', [at(0.55, 0.90), at(0.58, 0.62)]),
      act(5, 'run', [at(0.38, 0.92), at(0.40, 0.70)]),
    ]),
    [
      act(1, 'pass', [at(0.48, 0.55), at(0.78, 0.28)], 2),
      act(2, 'run', [at(0.78, 0.28), at(0.62, 0.14)]),
      act(2, 'shoot', [at(0.62, 0.14), at(0.50, 0.08)]),
      act(3, 'run', [at(0.18, 0.40), at(0.22, 0.18)]),
      act(4, 'run', [at(0.58, 0.62), at(0.60, 0.30)]),
      act(5, 'run', [at(0.40, 0.70), at(0.42, 0.36)]),
      act(1, 'dribble', [at(0.48, 0.55)], 1),
    ],
  ]),
  'fast-02': courtPlay('Three-Lane Break', [
    hold(1, at(0.50, 0.84), [
      act(1, 'run', [at(0.50, 0.84), at(0.50, 0.48)]),
      act(2, 'run', [at(0.78, 0.80), at(0.82, 0.22)]),
      act(3, 'run', [at(0.22, 0.80), at(0.18, 0.22)]),
      act(4, 'run', [at(0.62, 0.90), at(0.66, 0.55)]),
      act(5, 'run', [at(0.36, 0.90), at(0.40, 0.58)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.48), at(0.82, 0.22)], 2),
      act(2, 'shoot', [at(0.82, 0.22), at(0.50, 0.08)]),
      act(3, 'run', [at(0.18, 0.22), at(0.28, 0.16)]),
      act(4, 'run', [at(0.66, 0.55), at(0.64, 0.28)]),
      act(5, 'run', [at(0.40, 0.58), at(0.42, 0.30)]),
      act(1, 'dribble', [at(0.50, 0.48)], 1),
    ],
  ]),
  'fast-03': courtPlay('Outlet Ahead', [
    hold(5, at(0.46, 0.90), [
      act(5, 'pass', [at(0.46, 0.90), at(0.28, 0.72)], 1),
      act(1, 'run', [at(0.28, 0.72), at(0.36, 0.40)]),
      act(2, 'run', [at(0.74, 0.78), at(0.80, 0.24)]),
      act(3, 'run', [at(0.18, 0.70), at(0.16, 0.30)]),
      act(4, 'run', [at(0.60, 0.86), at(0.62, 0.50)]),
    ]),
    [
      act(1, 'pass', [at(0.36, 0.40), at(0.80, 0.24)], 2),
      act(2, 'shoot', [at(0.80, 0.24), at(0.50, 0.08)]),
      act(3, 'run', [at(0.16, 0.30), at(0.24, 0.16)]),
      act(4, 'run', [at(0.62, 0.50), at(0.58, 0.22)]),
      act(5, 'run', [at(0.46, 0.90), at(0.48, 0.55)]),
      act(1, 'dribble', [at(0.36, 0.40)], 1),
    ],
  ]),
  'fast-04': courtPlay('Rim Runner', [
    hold(1, at(0.50, 0.78), [
      act(1, 'run', [at(0.50, 0.78), at(0.50, 0.42)]),
      act(5, 'run', [at(0.50, 0.88), at(0.50, 0.16)]),
      act(2, 'run', [at(0.76, 0.74), at(0.84, 0.26)]),
      act(3, 'run', [at(0.24, 0.74), at(0.16, 0.26)]),
      act(4, 'run', [at(0.64, 0.86), at(0.66, 0.48)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.42), at(0.50, 0.16)], 5),
      act(5, 'shoot', [at(0.50, 0.16), at(0.50, 0.08)]),
      act(2, 'run', [at(0.84, 0.26)]),
      act(3, 'run', [at(0.16, 0.26)]),
      act(4, 'run', [at(0.66, 0.48), at(0.62, 0.28)]),
      act(1, 'dribble', [at(0.50, 0.42)], 1),
    ],
  ]),
  'fast-05': courtPlay('Sideline Push', [
    hold(1, at(0.20, 0.80), [
      act(1, 'run', [at(0.20, 0.80), at(0.22, 0.46)]),
      act(2, 'run', [at(0.20, 0.62), at(0.28, 0.20)]),
      act(3, 'run', [at(0.48, 0.84), at(0.70, 0.30)]),
      act(4, 'run', [at(0.55, 0.90), at(0.58, 0.55)]),
      act(5, 'run', [at(0.40, 0.92), at(0.46, 0.60)]),
    ]),
    [
      act(1, 'pass', [at(0.22, 0.46), at(0.28, 0.20)], 2),
      act(2, 'shoot', [at(0.28, 0.20), at(0.50, 0.08)]),
      act(3, 'run', [at(0.70, 0.30), at(0.78, 0.18)]),
      act(4, 'run', [at(0.58, 0.55), at(0.64, 0.30)]),
      act(5, 'run', [at(0.46, 0.60), at(0.48, 0.34)]),
      act(1, 'dribble', [at(0.22, 0.46)], 1),
    ],
  ]),
  'fast-06': courtPlay('Trail Screen', [
    hold(1, at(0.48, 0.70), [
      act(1, 'run', [at(0.48, 0.70), at(0.50, 0.36)]),
      act(2, 'run', [at(0.78, 0.55), at(0.82, 0.24)]),
      act(4, 'screen', [at(0.62, 0.48), at(0.74, 0.30)]),
      act(3, 'run', [at(0.18, 0.50), at(0.16, 0.22)]),
      act(5, 'run', [at(0.40, 0.78), at(0.42, 0.40)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.36), at(0.82, 0.24)], 2),
      act(2, 'shoot', [at(0.82, 0.24), at(0.50, 0.08)]),
      act(4, 'run', [at(0.74, 0.30), at(0.60, 0.16)]),
      act(3, 'run', [at(0.16, 0.22)]),
      act(5, 'run', [at(0.42, 0.40), at(0.40, 0.22)]),
      act(1, 'dribble', [at(0.50, 0.36)], 1),
    ],
  ]),
  'fast-07': courtPlay('Early Drag', [
    hold(1, at(0.50, 0.62), [
      act(1, 'run', [at(0.50, 0.62), at(0.42, 0.34)]),
      act(5, 'screen', [at(0.50, 0.50), at(0.40, 0.36)]),
      act(2, 'run', [at(0.76, 0.48), at(0.84, 0.22)]),
      act(3, 'run', [at(0.20, 0.48), at(0.16, 0.24)]),
      act(4, 'run', [at(0.64, 0.70), at(0.66, 0.40)]),
    ]),
    [
      act(1, 'run', [at(0.42, 0.34), at(0.36, 0.18)]),
      act(1, 'shoot', [at(0.36, 0.18), at(0.50, 0.08)]),
      act(5, 'run', [at(0.40, 0.36), at(0.48, 0.16)]),
      act(2, 'run', [at(0.84, 0.22)]),
      act(3, 'run', [at(0.16, 0.24)]),
      act(4, 'run', [at(0.66, 0.40), at(0.72, 0.22)]),
      act(1, 'dribble', [at(0.42, 0.34)], 1),
    ],
  ]),
  'fast-08': courtPlay('Numbers Kick', [
    hold(1, at(0.46, 0.58), [
      act(1, 'run', [at(0.46, 0.58), at(0.50, 0.30)]),
      act(2, 'run', [at(0.80, 0.40), at(0.86, 0.18)]),
      act(3, 'run', [at(0.18, 0.42), at(0.14, 0.18)]),
      act(4, 'run', [at(0.62, 0.66), at(0.64, 0.28)]),
      act(5, 'run', [at(0.34, 0.70), at(0.40, 0.24)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.30), at(0.14, 0.18)], 3),
      act(3, 'shoot', [at(0.14, 0.18), at(0.50, 0.08)]),
      act(2, 'run', [at(0.86, 0.18), at(0.78, 0.14)]),
      act(4, 'run', [at(0.64, 0.28), at(0.60, 0.16)]),
      act(5, 'run', [at(0.40, 0.24), at(0.46, 0.14)]),
      act(1, 'dribble', [at(0.50, 0.30)], 1),
    ],
  ]),
  'in-01': courtPlay('Baseline Stack', [
    hold(1, at(0.50, 0.05), [
      act(1, 'run', [at(0.50, 0.05)]),
      act(5, 'screen', [at(0.62, 0.16), at(0.62, 0.22)]),
      act(4, 'screen', [at(0.62, 0.22), at(0.62, 0.28)]),
      act(2, 'run', [at(0.62, 0.28), at(0.82, 0.30)]),
      act(3, 'run', [at(0.38, 0.18), at(0.28, 0.16)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.05), at(0.82, 0.30)], 2),
      act(2, 'shoot', [at(0.82, 0.30), at(0.50, 0.08)]),
      act(5, 'run', [at(0.62, 0.22), at(0.52, 0.14)]),
      act(4, 'run', [at(0.62, 0.28), at(0.70, 0.16)]),
      act(3, 'run', [at(0.28, 0.16)]),
      act(1, 'dribble', [at(0.50, 0.05)], 1),
    ],
  ]),
  'in-02': courtPlay('Box Baseline', [
    hold(1, at(0.08, 0.14), [
      act(1, 'run', [at(0.08, 0.14)]),
      act(4, 'screen', [at(0.36, 0.24), at(0.42, 0.20)]),
      act(5, 'screen', [at(0.64, 0.24), at(0.58, 0.20)]),
      act(2, 'run', [at(0.64, 0.14), at(0.50, 0.16)]),
      act(3, 'run', [at(0.36, 0.14), at(0.22, 0.28)]),
    ]),
    [
      act(1, 'pass', [at(0.08, 0.14), at(0.50, 0.16)], 2),
      act(2, 'shoot', [at(0.50, 0.16), at(0.50, 0.08)]),
      act(4, 'run', [at(0.42, 0.20), at(0.30, 0.28)]),
      act(5, 'run', [at(0.58, 0.20), at(0.72, 0.26)]),
      act(3, 'run', [at(0.22, 0.28)]),
      act(1, 'dribble', [at(0.08, 0.14)], 1),
    ],
  ]),
  'in-03': courtPlay('Sideline Horns', [
    hold(1, at(0.06, 0.32), [
      act(1, 'run', [at(0.06, 0.32)]),
      act(4, 'screen', [at(0.40, 0.26), at(0.46, 0.30)]),
      act(5, 'screen', [at(0.60, 0.26), at(0.66, 0.30)]),
      act(2, 'run', [at(0.46, 0.18), at(0.78, 0.30)]),
      act(3, 'run', [at(0.34, 0.18), at(0.22, 0.16)]),
    ]),
    [
      act(1, 'pass', [at(0.06, 0.32), at(0.78, 0.30)], 2),
      act(2, 'shoot', [at(0.78, 0.30), at(0.50, 0.08)]),
      act(4, 'run', [at(0.46, 0.30), at(0.42, 0.16)]),
      act(5, 'run', [at(0.66, 0.30), at(0.58, 0.14)]),
      act(3, 'run', [at(0.22, 0.16)]),
      act(1, 'dribble', [at(0.06, 0.32)], 1),
    ],
  ]),
  'in-04': courtPlay('Zipper Inbounds', [
    hold(1, at(0.08, 0.36), [
      act(1, 'run', [at(0.08, 0.36)]),
      act(5, 'screen', [at(0.50, 0.18), at(0.50, 0.28)]),
      act(2, 'run', [at(0.50, 0.12), at(0.50, 0.34)]),
      act(4, 'run', [at(0.66, 0.22), at(0.78, 0.18)]),
      act(3, 'run', [at(0.34, 0.22), at(0.22, 0.18)]),
    ]),
    [
      act(1, 'pass', [at(0.08, 0.36), at(0.50, 0.34)], 2),
      act(2, 'shoot', [at(0.50, 0.34), at(0.50, 0.08)]),
      act(5, 'run', [at(0.50, 0.28), at(0.42, 0.16)]),
      act(4, 'run', [at(0.78, 0.18)]),
      act(3, 'run', [at(0.22, 0.18)]),
      act(1, 'dribble', [at(0.08, 0.36)], 1),
    ],
  ]),
  'ato-01': courtPlay('Game Winner Floppy', [
    hold(1, at(0.50, 0.38), [
      act(1, 'run', [at(0.50, 0.38)]),
      act(5, 'screen', [at(0.62, 0.16), at(0.74, 0.22)]),
      act(4, 'screen', [at(0.38, 0.16), at(0.26, 0.22)]),
      act(2, 'run', [at(0.50, 0.10), at(0.84, 0.28)]),
      act(3, 'run', [at(0.50, 0.12), at(0.16, 0.28)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.38), at(0.84, 0.28)], 2),
      act(2, 'shoot', [at(0.84, 0.28), at(0.50, 0.08)]),
      act(5, 'run', [at(0.74, 0.22), at(0.62, 0.14)]),
      act(4, 'run', [at(0.26, 0.22), at(0.36, 0.14)]),
      act(3, 'run', [at(0.16, 0.28)]),
      act(1, 'dribble', [at(0.50, 0.38)], 1),
    ],
  ]),
  'ato-02': courtPlay('Isolation Clear', [
    hold(1, at(0.72, 0.32), [
      act(1, 'run', [at(0.72, 0.32), at(0.62, 0.18)]),
      act(1, 'shoot', [at(0.62, 0.18), at(0.50, 0.08)]),
      act(2, 'run', [at(0.84, 0.24), at(0.90, 0.14)]),
      act(3, 'run', [at(0.30, 0.30), at(0.14, 0.16)]),
      act(4, 'run', [at(0.40, 0.20), at(0.22, 0.28)]),
      act(5, 'run', [at(0.55, 0.16), at(0.36, 0.12)]),
    ]),
  ]),
  'ato-03': courtPlay('BLOB Buzzer', [
    hold(1, at(0.50, 0.05), [
      act(1, 'run', [at(0.50, 0.05)]),
      act(5, 'screen', [at(0.58, 0.18), at(0.66, 0.14)]),
      act(4, 'screen', [at(0.42, 0.20), at(0.34, 0.16)]),
      act(2, 'run', [at(0.62, 0.26), at(0.78, 0.14)]),
      act(3, 'run', [at(0.36, 0.26), at(0.22, 0.30)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.05), at(0.78, 0.14)], 2),
      act(2, 'shoot', [at(0.78, 0.14), at(0.50, 0.08)]),
      act(5, 'run', [at(0.66, 0.14), at(0.56, 0.12)]),
      act(4, 'run', [at(0.34, 0.16)]),
      act(3, 'run', [at(0.22, 0.30)]),
      act(1, 'dribble', [at(0.50, 0.05)], 1),
    ],
  ]),
  'ato-04': courtPlay('SLOB Hammer', [
    hold(1, at(0.06, 0.30), [
      act(1, 'run', [at(0.06, 0.30)]),
      act(5, 'screen', [at(0.70, 0.18), at(0.78, 0.14)]),
      act(4, 'screen', [at(0.55, 0.24), at(0.62, 0.20)]),
      act(2, 'run', [at(0.40, 0.20), at(0.86, 0.14)]),
      act(3, 'run', [at(0.28, 0.28), at(0.20, 0.16)]),
    ]),
    [
      act(1, 'pass', [at(0.06, 0.30), at(0.86, 0.14)], 2),
      act(2, 'shoot', [at(0.86, 0.14), at(0.50, 0.08)]),
      act(5, 'run', [at(0.78, 0.14), at(0.64, 0.12)]),
      act(4, 'run', [at(0.62, 0.20), at(0.50, 0.28)]),
      act(3, 'run', [at(0.20, 0.16)]),
      act(1, 'dribble', [at(0.06, 0.30)], 1),
    ],
  ]),
  'press-01': courtPlay('1-4 Press Break', [
    hold(1, at(0.50, 0.90), [
      act(1, 'run', [at(0.50, 0.90), at(0.50, 0.72)]),
      act(2, 'run', [at(0.82, 0.78), at(0.84, 0.55)]),
      act(3, 'run', [at(0.18, 0.78), at(0.16, 0.55)]),
      act(4, 'run', [at(0.66, 0.70), at(0.70, 0.42)]),
      act(5, 'run', [at(0.34, 0.70), at(0.30, 0.42)]),
    ]),
    [
      act(1, 'pass', [at(0.50, 0.72), at(0.84, 0.55)], 2),
      act(2, 'run', [at(0.84, 0.55), at(0.78, 0.22)]),
      act(3, 'run', [at(0.16, 0.55), at(0.20, 0.24)]),
      act(4, 'run', [at(0.70, 0.42), at(0.62, 0.18)]),
      act(5, 'run', [at(0.30, 0.42), at(0.40, 0.20)]),
      act(1, 'dribble', [at(0.50, 0.72)], 1),
    ],
  ]),
  'press-02': courtPlay('Middle Attack', [
    hold(1, at(0.28, 0.82), [
      act(1, 'pass', [at(0.28, 0.82), at(0.50, 0.68)], 5),
      act(5, 'run', [at(0.50, 0.68), at(0.50, 0.40)]),
      act(2, 'run', [at(0.78, 0.70), at(0.82, 0.36)]),
      act(3, 'run', [at(0.18, 0.64), at(0.16, 0.36)]),
      act(4, 'run', [at(0.64, 0.78), at(0.66, 0.48)]),
    ]),
    [
      act(5, 'pass', [at(0.50, 0.40), at(0.82, 0.36)], 2),
      act(2, 'run', [at(0.82, 0.36), at(0.70, 0.16)]),
      act(2, 'shoot', [at(0.70, 0.16), at(0.50, 0.08)]),
      act(3, 'run', [at(0.16, 0.36), at(0.22, 0.18)]),
      act(4, 'run', [at(0.66, 0.48), at(0.60, 0.24)]),
      act(1, 'run', [at(0.28, 0.82), at(0.40, 0.50)]),
      act(5, 'dribble', [at(0.50, 0.40)], 5),
    ],
  ]),
  'press-03': courtPlay('Sideline Safety', [
    hold(1, at(0.50, 0.88), [
      act(1, 'pass', [at(0.50, 0.88), at(0.16, 0.74)], 3),
      act(3, 'run', [at(0.16, 0.74), at(0.18, 0.48)]),
      act(2, 'run', [at(0.80, 0.76), at(0.82, 0.40)]),
      act(4, 'run', [at(0.62, 0.80), at(0.66, 0.52)]),
      act(5, 'run', [at(0.40, 0.78), at(0.46, 0.55)]),
    ]),
    [
      act(3, 'pass', [at(0.18, 0.48), at(0.46, 0.55)], 5),
      act(5, 'run', [at(0.46, 0.55), at(0.50, 0.28)]),
      act(2, 'run', [at(0.82, 0.40), at(0.78, 0.18)]),
      act(4, 'run', [at(0.66, 0.52), at(0.64, 0.24)]),
      act(1, 'run', [at(0.50, 0.88), at(0.40, 0.60)]),
      act(3, 'dribble', [at(0.18, 0.48)], 3),
    ],
  ]),
  'press-04': courtPlay('2-1-2 Press Break', [
    hold(1, at(0.36, 0.90), [
      act(1, 'run', [at(0.36, 0.90), at(0.40, 0.70)]),
      act(2, 'run', [at(0.64, 0.90), at(0.72, 0.62)]),
      act(5, 'run', [at(0.50, 0.74), at(0.50, 0.46)]),
      act(3, 'run', [at(0.18, 0.62), at(0.16, 0.34)]),
      act(4, 'run', [at(0.82, 0.62), at(0.84, 0.34)]),
    ]),
    [
      act(1, 'pass', [at(0.40, 0.70), at(0.50, 0.46)], 5),
      act(5, 'pass', [at(0.50, 0.46), at(0.84, 0.34)], 4),
      act(4, 'run', [at(0.84, 0.34), at(0.72, 0.16)]),
      act(3, 'run', [at(0.16, 0.34), at(0.24, 0.18)]),
      act(2, 'run', [at(0.72, 0.62), at(0.66, 0.30)]),
      act(1, 'dribble', [at(0.40, 0.70)], 1),
    ],
  ]),
};
