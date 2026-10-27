part of 'playbook_data.dart';

const _grokHalfCourtJson = r'''
[
  {
    "title": "西班牙擋拆",
    "englishTitle": "Spain Pick & Roll",
    "tags": ["半場", "擋拆", "西班牙"],
    "frames": [
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 320}, {"x": 200, "y": 300}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 60, "y": 280}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 340, "y": 280}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 120, "y": 120}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 200, "y": 160}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 300}, {"x": 170, "y": 240}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 200, "y": 160}, {"x": 175, "y": 230}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 120, "y": 120}, {"x": 190, "y": 90}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 170, "y": 240}, {"x": 190, "y": 90}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "shoot", "path": [{"x": 190, "y": 90}, {"x": 200, "y": 40}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 175, "y": 230}, {"x": 210, "y": 100}]}
        ]
      }
    ]
  },
  {
    "title": "牛角外彈",
    "englishTitle": "Horns Flare",
    "tags": ["半場", "牛角", "外彈"],
    "frames": [
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 330}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 50, "y": 260}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 350, "y": 260}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 150, "y": 140}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 250, "y": 140}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 330}, {"x": 150, "y": 140}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 150, "y": 140}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 50, "y": 260}, {"x": 90, "y": 160}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 250, "y": 140}, {"x": 280, "y": 200}]}
        ]
      },
      {
        "ballCarrierId": 4,
        "players": [
          {"id": 4, "team": "red", "number": "4", "actionType": "pass", "path": [{"x": 150, "y": 140}, {"x": 330, "y": 220}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 350, "y": 260}, {"x": 330, "y": 220}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 280, "y": 200}, {"x": 310, "y": 230}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "shoot", "path": [{"x": 330, "y": 220}, {"x": 200, "y": 40}]}
        ]
      }
    ]
  },
  {
    "title": "電梯門",
    "englishTitle": "Elevator Doors",
    "tags": ["半場", "電梯門", "投籃"],
    "frames": [
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 320}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 200, "y": 80}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 160, "y": 130}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 240, "y": 130}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 60, "y": 250}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 200, "y": 80}, {"x": 200, "y": 200}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 160, "y": 130}, {"x": 175, "y": 190}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 240, "y": 130}, {"x": 225, "y": 190}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 200, "y": 200}, {"x": 200, "y": 280}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 175, "y": 190}, {"x": 185, "y": 260}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 225, "y": 190}, {"x": 215, "y": 260}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 320}, {"x": 200, "y": 280}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "shoot", "path": [{"x": 200, "y": 280}, {"x": 200, "y": 40}]}
        ]
      }
    ]
  },
  {
    "title": "五外空手切",
    "englishTitle": "5-Out Backdoor",
    "tags": ["半場", "五外", "空手切"],
    "frames": [
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 340}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 40, "y": 220}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 360, "y": 220}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 80, "y": 80}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 320, "y": 80}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 340}, {"x": 40, "y": 220}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 40, "y": 220}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 80, "y": 80}, {"x": 140, "y": 140}]}
        ]
      },
      {
        "ballCarrierId": 2,
        "players": [
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 140, "y": 140}, {"x": 200, "y": 60}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "pass", "path": [{"x": 40, "y": 220}, {"x": 200, "y": 60}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "shoot", "path": [{"x": 200, "y": 60}, {"x": 200, "y": 40}]}
        ]
      }
    ]
  },
  {
    "title": "軟盤掩護",
    "englishTitle": "Floppy",
    "tags": ["半場", "軟盤", "掩護"],
    "frames": [
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 320}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 200, "y": 70}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 140, "y": 100}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 260, "y": 100}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 350, "y": 250}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 200, "y": 70}, {"x": 260, "y": 100}, {"x": 340, "y": 200}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 260, "y": 100}, {"x": 290, "y": 140}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 140, "y": 100}, {"x": 160, "y": 120}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 320}, {"x": 340, "y": 200}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "shoot", "path": [{"x": 340, "y": 200}, {"x": 200, "y": 40}]}
        ]
      }
    ]
  },
  {
    "title": "側翼雙擋",
    "englishTitle": "Wing Double Screen",
    "tags": ["半場", "雙擋", "側翼"],
    "frames": [
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 80, "y": 300}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 320, "y": 280}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 60, "y": 100}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 180, "y": 160}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 220, "y": 120}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 320, "y": 280}, {"x": 220, "y": 120}, {"x": 100, "y": 180}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 220, "y": 120}, {"x": 200, "y": 150}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 180, "y": 160}, {"x": 160, "y": 170}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 80, "y": 300}, {"x": 100, "y": 180}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "shoot", "path": [{"x": 100, "y": 180}, {"x": 200, "y": 40}]}
        ]
      }
    ]
  },
  {
    "title": "高位手遞手",
    "englishTitle": "High Handoff",
    "tags": ["半場", "手遞手", "高位"],
    "frames": [
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 300}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 200, "y": 160}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 50, "y": 240}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 350, "y": 240}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 260, "y": 80}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 300}, {"x": 200, "y": 160}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 200, "y": 160}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 50, "y": 240}, {"x": 180, "y": 170}]}
        ]
      },
      {
        "ballCarrierId": 4,
        "players": [
          {"id": 4, "team": "red", "number": "4", "actionType": "pass", "path": [{"x": 200, "y": 160}, {"x": 180, "y": 170}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 180, "y": 170}, {"x": 140, "y": 100}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 200, "y": 160}, {"x": 170, "y": 140}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "shoot", "path": [{"x": 140, "y": 100}, {"x": 200, "y": 40}]}
        ]
      }
    ]
  },
  {
    "title": "底角 trans 擋拆",
    "englishTitle": "Corner Pick & Roll",
    "tags": ["半場", "擋拆", "底角"],
    "frames": [
      {
        "ballCarrierId": 2,
        "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 40, "y": 80}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 120, "y": 140}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 320}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 360, "y": 250}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 280, "y": 100}]}
        ]
      },
      {
        "ballCarrierId": 2,
        "players": [
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 120, "y": 140}, {"x": 70, "y": 100}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 40, "y": 80}, {"x": 100, "y": 160}]}
        ]
      },
      {
        "ballCarrierId": 2,
        "players": [
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 70, "y": 100}, {"x": 180, "y": 70}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "pass", "path": [{"x": 100, "y": 160}, {"x": 180, "y": 70}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "shoot", "path": [{"x": 180, "y": 70}, {"x": 200, "y": 40}]}
        ]
      }
    ]
  },
  {
    "title": "箱形切入",
    "englishTitle": "Box Cut",
    "tags": ["半場", "箱形", "切入"],
    "frames": [
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 330}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 140, "y": 120}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 260, "y": 120}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 140, "y": 60}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 260, "y": 60}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 140, "y": 60}, {"x": 80, "y": 200}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 260, "y": 60}, {"x": 200, "y": 90}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 140, "y": 120}, {"x": 160, "y": 90}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 260, "y": 120}, {"x": 230, "y": 90}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 330}, {"x": 200, "y": 90}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "shoot", "path": [{"x": 200, "y": 90}, {"x": 200, "y": 40}]}
        ]
      }
    ]
  },
  {
    "title": "弱側交叉掩護",
    "englishTitle": "Weak-side Cross Screen",
    "tags": ["半場", "交叉掩護", "弱側"],
    "frames": [
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 80, "y": 300}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 60, "y": 200}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 340, "y": 240}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 180, "y": 80}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 280, "y": 100}]}
        ]
      },
      {
        "ballCarrierId": 1,
        "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 80, "y": 300}, {"x": 60, "y": 200}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 280, "y": 100}, {"x": 200, "y": 90}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 180, "y": 80}, {"x": 300, "y": 70}]}
        ]
      },
      {
        "ballCarrierId": 2,
        "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "pass", "path": [{"x": 60, "y": 200}, {"x": 300, "y": 70}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "shoot", "path": [{"x": 300, "y": 70}, {"x": 200, "y": 40}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 340, "y": 240}, {"x": 320, "y": 160}]}
        ]
      }
    ]
  }
]
''';
