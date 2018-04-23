import 'dart:async';
// ignore: unused_import
import 'package:meta/meta.dart' show required;
import '../src/connection.dart';

class InputManager {
  final Client _client;

  InputManager(this._client);

  /// Ignores input events (useful while auditing page).
  /// [ignore] Ignores input events processing when set to true.
  Future setIgnoreInputEvents(
    bool ignore,
  ) async {
    Map parameters = {
      'ignore': ignore,
    };
    await _client.send('Input.setIgnoreInputEvents', parameters);
  }

  /// Dispatches a key event to the page.
  /// [type] Type of the key event.
  /// [modifiers] Bit field representing pressed modifier keys. Alt=1, Ctrl=2,
  /// Meta/Command=4, Shift=8 (default: 0).
  /// [timestamp] Time at which the event occurred.
  /// [text] Text as generated by processing a virtual key code with a keyboard
  /// layout. Not needed for for `keyUp` and `rawKeyDown` events (default: "")
  /// [unmodifiedText] Text that would have been generated by the keyboard if no
  /// modifiers were pressed (except for shift). Useful for shortcut (accelerator)
  /// key handling (default: "").
  /// [keyIdentifier] Unique key identifier (e.g., 'U+0041') (default: "").
  /// [code] Unique DOM defined string value for each physical key (e.g., 'KeyA')
  /// (default: "").
  /// [key] Unique DOM defined string value describing the meaning of the key in
  /// the context of active modifiers, keyboard layout, etc (e.g., 'AltGr')
  /// (default: "").
  /// [windowsVirtualKeyCode] Windows virtual key code (default: 0).
  /// [nativeVirtualKeyCode] Native virtual key code (default: 0).
  /// [autoRepeat] Whether the event was generated from auto repeat (default:
  /// false).
  /// [isKeypad] Whether the event was generated from the keypad (default: false).
  /// [isSystemKey] Whether the event was a system key event (default: false).
  /// [location] Whether the event was from the left or right side of the
  /// keyboard. 1=Left, 2=Right (default: 0).
  Future dispatchKeyEvent(
    String type, {
    int modifiers,
    TimeSinceEpoch timestamp,
    String text,
    String unmodifiedText,
    String keyIdentifier,
    String code,
    String key,
    int windowsVirtualKeyCode,
    int nativeVirtualKeyCode,
    bool autoRepeat,
    bool isKeypad,
    bool isSystemKey,
    int location,
  }) async {
    Map parameters = {
      'type': type,
    };
    if (modifiers != null) {
      parameters['modifiers'] = modifiers;
    }
    if (timestamp != null) {
      parameters['timestamp'] = timestamp.toJson();
    }
    if (text != null) {
      parameters['text'] = text;
    }
    if (unmodifiedText != null) {
      parameters['unmodifiedText'] = unmodifiedText;
    }
    if (keyIdentifier != null) {
      parameters['keyIdentifier'] = keyIdentifier;
    }
    if (code != null) {
      parameters['code'] = code;
    }
    if (key != null) {
      parameters['key'] = key;
    }
    if (windowsVirtualKeyCode != null) {
      parameters['windowsVirtualKeyCode'] = windowsVirtualKeyCode;
    }
    if (nativeVirtualKeyCode != null) {
      parameters['nativeVirtualKeyCode'] = nativeVirtualKeyCode;
    }
    if (autoRepeat != null) {
      parameters['autoRepeat'] = autoRepeat;
    }
    if (isKeypad != null) {
      parameters['isKeypad'] = isKeypad;
    }
    if (isSystemKey != null) {
      parameters['isSystemKey'] = isSystemKey;
    }
    if (location != null) {
      parameters['location'] = location;
    }
    await _client.send('Input.dispatchKeyEvent', parameters);
  }

  /// Dispatches a mouse event to the page.
  /// [type] Type of the mouse event.
  /// [x] X coordinate of the event relative to the main frame's viewport in CSS
  /// pixels.
  /// [y] Y coordinate of the event relative to the main frame's viewport in CSS
  /// pixels. 0 refers to the top of the viewport and Y increases as it proceeds
  /// towards the bottom of the viewport.
  /// [modifiers] Bit field representing pressed modifier keys. Alt=1, Ctrl=2,
  /// Meta/Command=4, Shift=8 (default: 0).
  /// [timestamp] Time at which the event occurred.
  /// [button] Mouse button (default: "none").
  /// [clickCount] Number of times the mouse button was clicked (default: 0).
  /// [deltaX] X delta in CSS pixels for mouse wheel event (default: 0).
  /// [deltaY] Y delta in CSS pixels for mouse wheel event (default: 0).
  Future dispatchMouseEvent(
    String type,
    num x,
    num y, {
    int modifiers,
    TimeSinceEpoch timestamp,
    String button,
    int clickCount,
    num deltaX,
    num deltaY,
  }) async {
    Map parameters = {
      'type': type,
      'x': x,
      'y': y,
    };
    if (modifiers != null) {
      parameters['modifiers'] = modifiers;
    }
    if (timestamp != null) {
      parameters['timestamp'] = timestamp.toJson();
    }
    if (button != null) {
      parameters['button'] = button;
    }
    if (clickCount != null) {
      parameters['clickCount'] = clickCount;
    }
    if (deltaX != null) {
      parameters['deltaX'] = deltaX;
    }
    if (deltaY != null) {
      parameters['deltaY'] = deltaY;
    }
    await _client.send('Input.dispatchMouseEvent', parameters);
  }

  /// Dispatches a touch event to the page.
  /// [type] Type of the touch event. TouchEnd and TouchCancel must not contain
  /// any touch points, while TouchStart and TouchMove must contains at least one.
  /// [touchPoints] Active touch points on the touch device. One event per any
  /// changed point (compared to previous touch event in a sequence) is generated,
  /// emulating pressing/moving/releasing points one by one.
  /// [modifiers] Bit field representing pressed modifier keys. Alt=1, Ctrl=2,
  /// Meta/Command=4, Shift=8 (default: 0).
  /// [timestamp] Time at which the event occurred.
  Future dispatchTouchEvent(
    String type,
    List<TouchPoint> touchPoints, {
    int modifiers,
    TimeSinceEpoch timestamp,
  }) async {
    Map parameters = {
      'type': type,
      'touchPoints': touchPoints.map((e) => e.toJson()).toList(),
    };
    if (modifiers != null) {
      parameters['modifiers'] = modifiers;
    }
    if (timestamp != null) {
      parameters['timestamp'] = timestamp.toJson();
    }
    await _client.send('Input.dispatchTouchEvent', parameters);
  }

  /// Emulates touch event from the mouse event parameters.
  /// [type] Type of the mouse event.
  /// [x] X coordinate of the mouse pointer in DIP.
  /// [y] Y coordinate of the mouse pointer in DIP.
  /// [timestamp] Time at which the event occurred.
  /// [button] Mouse button.
  /// [deltaX] X delta in DIP for mouse wheel event (default: 0).
  /// [deltaY] Y delta in DIP for mouse wheel event (default: 0).
  /// [modifiers] Bit field representing pressed modifier keys. Alt=1, Ctrl=2,
  /// Meta/Command=4, Shift=8 (default: 0).
  /// [clickCount] Number of times the mouse button was clicked (default: 0).
  Future emulateTouchFromMouseEvent(
    String type,
    int x,
    int y,
    TimeSinceEpoch timestamp,
    String button, {
    num deltaX,
    num deltaY,
    int modifiers,
    int clickCount,
  }) async {
    Map parameters = {
      'type': type,
      'x': x,
      'y': y,
      'timestamp': timestamp.toJson(),
      'button': button,
    };
    if (deltaX != null) {
      parameters['deltaX'] = deltaX;
    }
    if (deltaY != null) {
      parameters['deltaY'] = deltaY;
    }
    if (modifiers != null) {
      parameters['modifiers'] = modifiers;
    }
    if (clickCount != null) {
      parameters['clickCount'] = clickCount;
    }
    await _client.send('Input.emulateTouchFromMouseEvent', parameters);
  }

  /// Synthesizes a pinch gesture over a time period by issuing appropriate touch
  /// events.
  /// [x] X coordinate of the start of the gesture in CSS pixels.
  /// [y] Y coordinate of the start of the gesture in CSS pixels.
  /// [scaleFactor] Relative scale factor after zooming (>1.0 zooms in, <1.0 zooms
  /// out).
  /// [relativeSpeed] Relative pointer speed in pixels per second (default: 800).
  /// [gestureSourceType] Which type of input events to be generated (default:
  /// 'default', which queries the platform for the preferred input type).
  Future synthesizePinchGesture(
    num x,
    num y,
    num scaleFactor, {
    int relativeSpeed,
    GestureSourceType gestureSourceType,
  }) async {
    Map parameters = {
      'x': x,
      'y': y,
      'scaleFactor': scaleFactor,
    };
    if (relativeSpeed != null) {
      parameters['relativeSpeed'] = relativeSpeed;
    }
    if (gestureSourceType != null) {
      parameters['gestureSourceType'] = gestureSourceType.toJson();
    }
    await _client.send('Input.synthesizePinchGesture', parameters);
  }

  /// Synthesizes a scroll gesture over a time period by issuing appropriate touch
  /// events.
  /// [x] X coordinate of the start of the gesture in CSS pixels.
  /// [y] Y coordinate of the start of the gesture in CSS pixels.
  /// [xDistance] The distance to scroll along the X axis (positive to scroll
  /// left).
  /// [yDistance] The distance to scroll along the Y axis (positive to scroll up).
  /// [xOverscroll] The number of additional pixels to scroll back along the X
  /// axis, in addition to the given distance.
  /// [yOverscroll] The number of additional pixels to scroll back along the Y
  /// axis, in addition to the given distance.
  /// [preventFling] Prevent fling (default: true).
  /// [speed] Swipe speed in pixels per second (default: 800).
  /// [gestureSourceType] Which type of input events to be generated (default:
  /// 'default', which queries the platform for the preferred input type).
  /// [repeatCount] The number of times to repeat the gesture (default: 0).
  /// [repeatDelayMs] The number of milliseconds delay between each repeat.
  /// (default: 250).
  /// [interactionMarkerName] The name of the interaction markers to generate, if
  /// not empty (default: "").
  Future synthesizeScrollGesture(
    num x,
    num y, {
    num xDistance,
    num yDistance,
    num xOverscroll,
    num yOverscroll,
    bool preventFling,
    int speed,
    GestureSourceType gestureSourceType,
    int repeatCount,
    int repeatDelayMs,
    String interactionMarkerName,
  }) async {
    Map parameters = {
      'x': x,
      'y': y,
    };
    if (xDistance != null) {
      parameters['xDistance'] = xDistance;
    }
    if (yDistance != null) {
      parameters['yDistance'] = yDistance;
    }
    if (xOverscroll != null) {
      parameters['xOverscroll'] = xOverscroll;
    }
    if (yOverscroll != null) {
      parameters['yOverscroll'] = yOverscroll;
    }
    if (preventFling != null) {
      parameters['preventFling'] = preventFling;
    }
    if (speed != null) {
      parameters['speed'] = speed;
    }
    if (gestureSourceType != null) {
      parameters['gestureSourceType'] = gestureSourceType.toJson();
    }
    if (repeatCount != null) {
      parameters['repeatCount'] = repeatCount;
    }
    if (repeatDelayMs != null) {
      parameters['repeatDelayMs'] = repeatDelayMs;
    }
    if (interactionMarkerName != null) {
      parameters['interactionMarkerName'] = interactionMarkerName;
    }
    await _client.send('Input.synthesizeScrollGesture', parameters);
  }

  /// Synthesizes a tap gesture over a time period by issuing appropriate touch
  /// events.
  /// [x] X coordinate of the start of the gesture in CSS pixels.
  /// [y] Y coordinate of the start of the gesture in CSS pixels.
  /// [duration] Duration between touchdown and touchup events in ms (default:
  /// 50).
  /// [tapCount] Number of times to perform the tap (e.g. 2 for double tap,
  /// default: 1).
  /// [gestureSourceType] Which type of input events to be generated (default:
  /// 'default', which queries the platform for the preferred input type).
  Future synthesizeTapGesture(
    num x,
    num y, {
    int duration,
    int tapCount,
    GestureSourceType gestureSourceType,
  }) async {
    Map parameters = {
      'x': x,
      'y': y,
    };
    if (duration != null) {
      parameters['duration'] = duration;
    }
    if (tapCount != null) {
      parameters['tapCount'] = tapCount;
    }
    if (gestureSourceType != null) {
      parameters['gestureSourceType'] = gestureSourceType.toJson();
    }
    await _client.send('Input.synthesizeTapGesture', parameters);
  }
}

class TouchPoint {
  /// X coordinate of the event relative to the main frame's viewport in CSS
  /// pixels.
  final num x;

  /// Y coordinate of the event relative to the main frame's viewport in CSS
  /// pixels. 0 refers to the top of the viewport and Y increases as it proceeds
  /// towards the bottom of the viewport.
  final num y;

  /// X radius of the touch area (default: 1.0).
  final num radiusX;

  /// Y radius of the touch area (default: 1.0).
  final num radiusY;

  /// Rotation angle (default: 0.0).
  final num rotationAngle;

  /// Force (default: 1.0).
  final num force;

  /// Identifier used to track touch sources between events, must be unique within
  /// an event.
  final num id;

  TouchPoint({
    @required this.x,
    @required this.y,
    this.radiusX,
    this.radiusY,
    this.rotationAngle,
    this.force,
    this.id,
  });

  factory TouchPoint.fromJson(Map json) {
    return new TouchPoint(
      x: json['x'],
      y: json['y'],
      radiusX: json.containsKey('radiusX') ? json['radiusX'] : null,
      radiusY: json.containsKey('radiusY') ? json['radiusY'] : null,
      rotationAngle:
          json.containsKey('rotationAngle') ? json['rotationAngle'] : null,
      force: json.containsKey('force') ? json['force'] : null,
      id: json.containsKey('id') ? json['id'] : null,
    );
  }

  Map toJson() {
    Map json = {
      'x': x,
      'y': y,
    };
    if (radiusX != null) {
      json['radiusX'] = radiusX;
    }
    if (radiusY != null) {
      json['radiusY'] = radiusY;
    }
    if (rotationAngle != null) {
      json['rotationAngle'] = rotationAngle;
    }
    if (force != null) {
      json['force'] = force;
    }
    if (id != null) {
      json['id'] = id;
    }
    return json;
  }
}

class GestureSourceType {
  static const GestureSourceType default$ =
      const GestureSourceType._('default');
  static const GestureSourceType touch = const GestureSourceType._('touch');
  static const GestureSourceType mouse = const GestureSourceType._('mouse');
  static const values = const {
    'default': default$,
    'touch': touch,
    'mouse': mouse,
  };

  final String value;

  const GestureSourceType._(this.value);

  factory GestureSourceType.fromJson(String value) => values[value];

  String toJson() => value;

  String toString() => value.toString();
}

/// UTC time in seconds, counted from January 1, 1970.
class TimeSinceEpoch {
  final num value;

  TimeSinceEpoch(this.value);

  factory TimeSinceEpoch.fromJson(num value) => new TimeSinceEpoch(value);

  num toJson() => value;

  bool operator ==(other) => other is TimeSinceEpoch && other.value == value;

  int get hashCode => value.hashCode;

  String toString() => value.toString();
}
