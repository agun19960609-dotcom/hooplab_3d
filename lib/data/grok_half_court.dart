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
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 320}, {"x": 248, "y": 236}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 188, "y": 168}, {"x": 296, "y": 204}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 372, "y": 36}, {"x": 328, "y": 118}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 52, "y": 210}, {"x": 58, "y": 178}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 24, "y": 40}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 248, "y": 236}, {"x": 330, "y": 180}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 296, "y": 204}, {"x": 214, "y": 78}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 328, "y": 118}, {"x": 230, "y": 180}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 58, "y": 178}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 24, "y": 40}, {"x": 40, "y": 78}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 330, "y": 180}, {"x": 214, "y": 78}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "shoot", "path": [{"x": 214, "y": 78}, {"x": 200, "y": 22}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 230, "y": 180}, {"x": 374, "y": 52}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 58, "y": 178}, {"x": 74, "y": 204}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 40, "y": 78}]}
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
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 340}, {"x": 200, "y": 255}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 128, "y": 150}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 272, "y": 150}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 372, "y": 38}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 28, "y": 38}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 255}, {"x": 128, "y": 150}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 128, "y": 150}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 272, "y": 150}, {"x": 324, "y": 132}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 372, "y": 38}, {"x": 356, "y": 190}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 28, "y": 38}, {"x": 46, "y": 92}]}
          ]
        },
        {
          "ballCarrierId": 4,
          "players": [
          {"id": 4, "team": "red", "number": "4", "actionType": "pass", "path": [{"x": 128, "y": 150}, {"x": 356, "y": 190}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "shoot", "path": [{"x": 356, "y": 190}, {"x": 200, "y": 22}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 324, "y": 132}, {"x": 230, "y": 66}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 255}, {"x": 164, "y": 228}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 46, "y": 92}, {"x": 58, "y": 170}]}
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
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 330}, {"x": 200, "y": 305}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 200, "y": 28}, {"x": 200, "y": 108}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 150, "y": 150}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 250, "y": 150}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 46, "y": 196}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 200, "y": 108}, {"x": 200, "y": 222}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 150, "y": 150}, {"x": 176, "y": 170}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 250, "y": 150}, {"x": 224, "y": 170}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 305}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 46, "y": 196}, {"x": 64, "y": 172}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 305}, {"x": 200, "y": 222}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "shoot", "path": [{"x": 200, "y": 222}, {"x": 200, "y": 22}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 176, "y": 170}, {"x": 112, "y": 148}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 224, "y": 170}, {"x": 288, "y": 148}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 64, "y": 172}]}
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
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 305}, {"x": 348, "y": 178}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 348, "y": 178}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 52, "y": 178}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 378, "y": 36}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 22, "y": 36}, {"x": 44, "y": 90}]}
          ]
        },
        {
          "ballCarrierId": 2,
          "players": [
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 378, "y": 36}, {"x": 292, "y": 50}, {"x": 222, "y": 56}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 348, "y": 178}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 305}, {"x": 268, "y": 236}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 52, "y": 178}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 44, "y": 90}]}
          ]
        },
        {
          "ballCarrierId": 2,
          "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "pass", "path": [{"x": 348, "y": 178}, {"x": 222, "y": 56}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "shoot", "path": [{"x": 222, "y": 56}, {"x": 200, "y": 20}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 268, "y": 236}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 52, "y": 178}, {"x": 72, "y": 162}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 44, "y": 90}]}
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
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 325}, {"x": 200, "y": 292}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 200, "y": 32}, {"x": 200, "y": 72}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 122, "y": 148}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 278, "y": 148}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 48, "y": 200}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 200, "y": 72}, {"x": 278, "y": 148}, {"x": 354, "y": 188}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 278, "y": 148}, {"x": 312, "y": 160}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 122, "y": 148}, {"x": 104, "y": 132}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 292}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 48, "y": 200}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 292}, {"x": 354, "y": 188}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "shoot", "path": [{"x": 354, "y": 188}, {"x": 200, "y": 22}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 312, "y": 160}, {"x": 236, "y": 70}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 104, "y": 132}, {"x": 108, "y": 190}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 48, "y": 200}]}
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
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 82, "y": 214}, {"x": 62, "y": 198}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 350, "y": 186}, {"x": 270, "y": 154}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 170, "y": 148}, {"x": 162, "y": 152}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 214, "y": 104}, {"x": 204, "y": 114}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 376, "y": 42}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 270, "y": 154}, {"x": 186, "y": 138}, {"x": 118, "y": 206}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 162, "y": 152}, {"x": 154, "y": 158}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 204, "y": 114}, {"x": 196, "y": 126}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 62, "y": 198}, {"x": 44, "y": 224}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 376, "y": 42}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 44, "y": 224}, {"x": 118, "y": 206}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "shoot", "path": [{"x": 118, "y": 206}, {"x": 200, "y": 22}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 154, "y": 158}, {"x": 146, "y": 74}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 196, "y": 126}, {"x": 252, "y": 150}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 376, "y": 42}, {"x": 338, "y": 100}]}
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
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 318}, {"x": 202, "y": 206}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 208, "y": 156}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 52, "y": 186}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 348, "y": 186}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 276, "y": 56}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 202, "y": 206}, {"x": 208, "y": 156}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "screen", "path": [{"x": 202, "y": 206}, {"x": 174, "y": 148}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 208, "y": 156}, {"x": 176, "y": 86}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 52, "y": 186}, {"x": 92, "y": 148}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 348, "y": 186}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 276, "y": 56}, {"x": 240, "y": 50}]}
          ]
        },
        {
          "ballCarrierId": 4,
          "players": [
          {"id": 4, "team": "red", "number": "4", "actionType": "shoot", "path": [{"x": 176, "y": 86}, {"x": 200, "y": 20}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 174, "y": 148}, {"x": 148, "y": 172}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 92, "y": 148}, {"x": 68, "y": 190}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 348, "y": 186}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "move", "path": [{"x": 240, "y": 50}]}
          ]
        }
    ]
  },
  {
    "title": "底角擋拆",
    "englishTitle": "Corner Pick & Roll",
    "tags": ["半場", "擋拆", "底角"],
    "frames": [
        {
          "ballCarrierId": 2,
          "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 34, "y": 46}, {"x": 66, "y": 80}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 146, "y": 158}, {"x": 114, "y": 104}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 312}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 346, "y": 184}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 290, "y": 60}]}
          ]
        },
        {
          "ballCarrierId": 2,
          "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 66, "y": 80}, {"x": 158, "y": 178}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 114, "y": 104}, {"x": 186, "y": 60}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 312}, {"x": 238, "y": 260}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 346, "y": 184}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 290, "y": 60}, {"x": 334, "y": 112}]}
          ]
        },
        {
          "ballCarrierId": 2,
          "players": [
          {"id": 2, "team": "red", "number": "2", "actionType": "pass", "path": [{"x": 158, "y": 178}, {"x": 186, "y": 60}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "shoot", "path": [{"x": 186, "y": 60}, {"x": 200, "y": 20}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 238, "y": 260}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 346, "y": 184}, {"x": 318, "y": 204}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 334, "y": 112}]}
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
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 328}, {"x": 200, "y": 270}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 136, "y": 44}, {"x": 58, "y": 160}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 264, "y": 44}, {"x": 200, "y": 92}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 126, "y": 150}, {"x": 150, "y": 128}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 274, "y": 150}, {"x": 250, "y": 128}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 200, "y": 92}, {"x": 200, "y": 174}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "screen", "path": [{"x": 150, "y": 128}, {"x": 162, "y": 148}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 250, "y": 128}, {"x": 238, "y": 148}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 58, "y": 160}, {"x": 46, "y": 190}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 200, "y": 270}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 200, "y": 270}, {"x": 200, "y": 174}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "shoot", "path": [{"x": 200, "y": 174}, {"x": 200, "y": 22}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 162, "y": 148}, {"x": 140, "y": 66}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 238, "y": 148}, {"x": 292, "y": 160}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 46, "y": 190}]}
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
          {"id": 1, "team": "red", "number": "1", "actionType": "run", "path": [{"x": 200, "y": 308}, {"x": 80, "y": 198}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "move", "path": [{"x": 34, "y": 46}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 346, "y": 186}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "move", "path": [{"x": 262, "y": 54}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 148, "y": 100}, {"x": 170, "y": 88}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 5, "team": "red", "number": "5", "actionType": "screen", "path": [{"x": 170, "y": 88}, {"x": 206, "y": 96}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "run", "path": [{"x": 262, "y": 54}, {"x": 150, "y": 48}]},
          {"id": 1, "team": "red", "number": "1", "actionType": "move", "path": [{"x": 80, "y": 198}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 34, "y": 46}, {"x": 50, "y": 132}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "move", "path": [{"x": 346, "y": 186}]}
          ]
        },
        {
          "ballCarrierId": 1,
          "players": [
          {"id": 1, "team": "red", "number": "1", "actionType": "pass", "path": [{"x": 80, "y": 198}, {"x": 150, "y": 48}]},
          {"id": 4, "team": "red", "number": "4", "actionType": "shoot", "path": [{"x": 150, "y": 48}, {"x": 200, "y": 20}]},
          {"id": 5, "team": "red", "number": "5", "actionType": "run", "path": [{"x": 206, "y": 96}, {"x": 258, "y": 140}]},
          {"id": 2, "team": "red", "number": "2", "actionType": "run", "path": [{"x": 50, "y": 132}, {"x": 42, "y": 172}]},
          {"id": 3, "team": "red", "number": "3", "actionType": "run", "path": [{"x": 346, "y": 186}, {"x": 304, "y": 208}]}
          ]
        }
    ]
  }
]
''';
