/// This domain provides various functionality related to drawing atop the
/// inspected page.

import 'dart:async';
// ignore: unused_import
import 'package:meta/meta.dart' show required;
import '../src/connection.dart';
import 'dom.dart' as dom;
import 'runtime.dart' as runtime;
import 'page.dart' as page;

class OverlayManager {
  final Client _client;

  OverlayManager(this._client);

  /// Fired when the node should be highlighted. This happens after call to
  /// `setInspectMode`.
  Stream<dom.NodeId> get onNodeHighlightRequested => _client.onEvent
      .where((Event event) => event.name == 'Overlay.nodeHighlightRequested')
      .map(
          (Event event) => new dom.NodeId.fromJson(event.parameters['nodeId']));

  /// Fired when the node should be inspected. This happens after call to
  /// `setInspectMode` or when user manually inspects an element.
  Stream<dom.BackendNodeId> get onInspectNodeRequested => _client.onEvent
      .where((Event event) => event.name == 'Overlay.inspectNodeRequested')
      .map((Event event) =>
          new dom.BackendNodeId.fromJson(event.parameters['backendNodeId']));

  /// Fired when user asks to capture screenshot of some area on the page.
  Stream<page.Viewport> get onScreenshotRequested => _client.onEvent
      .where((Event event) => event.name == 'Overlay.screenshotRequested')
      .map((Event event) =>
          new page.Viewport.fromJson(event.parameters['viewport']));

  /// Enables domain notifications.
  Future enable() async {
    await _client.send('Overlay.enable');
  }

  /// Disables domain notifications.
  Future disable() async {
    await _client.send('Overlay.disable');
  }

  /// Requests that backend shows paint rectangles
  /// [result] True for showing paint rectangles
  Future setShowPaintRects(
    bool result,
  ) async {
    Map parameters = {
      'result': result,
    };
    await _client.send('Overlay.setShowPaintRects', parameters);
  }

  /// Requests that backend shows debug borders on layers
  /// [show] True for showing debug borders
  Future setShowDebugBorders(
    bool show,
  ) async {
    Map parameters = {
      'show': show,
    };
    await _client.send('Overlay.setShowDebugBorders', parameters);
  }

  /// Requests that backend shows the FPS counter
  /// [show] True for showing the FPS counter
  Future setShowFPSCounter(
    bool show,
  ) async {
    Map parameters = {
      'show': show,
    };
    await _client.send('Overlay.setShowFPSCounter', parameters);
  }

  /// Requests that backend shows scroll bottleneck rects
  /// [show] True for showing scroll bottleneck rects
  Future setShowScrollBottleneckRects(
    bool show,
  ) async {
    Map parameters = {
      'show': show,
    };
    await _client.send('Overlay.setShowScrollBottleneckRects', parameters);
  }

  /// Paints viewport size upon main frame resize.
  /// [show] Whether to paint size or not.
  Future setShowViewportSizeOnResize(
    bool show,
  ) async {
    Map parameters = {
      'show': show,
    };
    await _client.send('Overlay.setShowViewportSizeOnResize', parameters);
  }

  /// [message] The message to display, also triggers resume and step over
  /// controls.
  Future setPausedInDebuggerMessage({
    String message,
  }) async {
    Map parameters = {};
    if (message != null) {
      parameters['message'] = message;
    }
    await _client.send('Overlay.setPausedInDebuggerMessage', parameters);
  }

  /// [suspended] Whether overlay should be suspended and not consume any
  /// resources until resumed.
  Future setSuspended(
    bool suspended,
  ) async {
    Map parameters = {
      'suspended': suspended,
    };
    await _client.send('Overlay.setSuspended', parameters);
  }

  /// Enters the 'inspect' mode. In this mode, elements that user is hovering over
  /// are highlighted. Backend then generates 'inspectNodeRequested' event upon
  /// element selection.
  /// [mode] Set an inspection mode.
  /// [highlightConfig] A descriptor for the highlight appearance of hovered-over
  /// nodes. May be omitted if `enabled == false`.
  Future setInspectMode(
    InspectMode mode, {
    HighlightConfig highlightConfig,
  }) async {
    Map parameters = {
      'mode': mode.toJson(),
    };
    if (highlightConfig != null) {
      parameters['highlightConfig'] = highlightConfig.toJson();
    }
    await _client.send('Overlay.setInspectMode', parameters);
  }

  /// Highlights given rectangle. Coordinates are absolute with respect to the
  /// main frame viewport.
  /// [x] X coordinate
  /// [y] Y coordinate
  /// [width] Rectangle width
  /// [height] Rectangle height
  /// [color] The highlight fill color (default: transparent).
  /// [outlineColor] The highlight outline color (default: transparent).
  Future highlightRect(
    int x,
    int y,
    int width,
    int height, {
    dom.RGBA color,
    dom.RGBA outlineColor,
  }) async {
    Map parameters = {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
    if (color != null) {
      parameters['color'] = color.toJson();
    }
    if (outlineColor != null) {
      parameters['outlineColor'] = outlineColor.toJson();
    }
    await _client.send('Overlay.highlightRect', parameters);
  }

  /// Highlights given quad. Coordinates are absolute with respect to the main
  /// frame viewport.
  /// [quad] Quad to highlight
  /// [color] The highlight fill color (default: transparent).
  /// [outlineColor] The highlight outline color (default: transparent).
  Future highlightQuad(
    dom.Quad quad, {
    dom.RGBA color,
    dom.RGBA outlineColor,
  }) async {
    Map parameters = {
      'quad': quad.toJson(),
    };
    if (color != null) {
      parameters['color'] = color.toJson();
    }
    if (outlineColor != null) {
      parameters['outlineColor'] = outlineColor.toJson();
    }
    await _client.send('Overlay.highlightQuad', parameters);
  }

  /// Highlights DOM node with given id or with the given JavaScript object
  /// wrapper. Either nodeId or objectId must be specified.
  /// [highlightConfig] A descriptor for the highlight appearance.
  /// [nodeId] Identifier of the node to highlight.
  /// [backendNodeId] Identifier of the backend node to highlight.
  /// [objectId] JavaScript object id of the node to be highlighted.
  Future highlightNode(
    HighlightConfig highlightConfig, {
    dom.NodeId nodeId,
    dom.BackendNodeId backendNodeId,
    runtime.RemoteObjectId objectId,
  }) async {
    Map parameters = {
      'highlightConfig': highlightConfig.toJson(),
    };
    if (nodeId != null) {
      parameters['nodeId'] = nodeId.toJson();
    }
    if (backendNodeId != null) {
      parameters['backendNodeId'] = backendNodeId.toJson();
    }
    if (objectId != null) {
      parameters['objectId'] = objectId.toJson();
    }
    await _client.send('Overlay.highlightNode', parameters);
  }

  /// Highlights owner element of the frame with given id.
  /// [frameId] Identifier of the frame to highlight.
  /// [contentColor] The content box highlight fill color (default: transparent).
  /// [contentOutlineColor] The content box highlight outline color (default:
  /// transparent).
  Future highlightFrame(
    page.FrameId frameId, {
    dom.RGBA contentColor,
    dom.RGBA contentOutlineColor,
  }) async {
    Map parameters = {
      'frameId': frameId.toJson(),
    };
    if (contentColor != null) {
      parameters['contentColor'] = contentColor.toJson();
    }
    if (contentOutlineColor != null) {
      parameters['contentOutlineColor'] = contentOutlineColor.toJson();
    }
    await _client.send('Overlay.highlightFrame', parameters);
  }

  /// Hides any highlight.
  Future hideHighlight() async {
    await _client.send('Overlay.hideHighlight');
  }

  /// For testing.
  /// [nodeId] Id of the node to get highlight object for.
  /// Return: Highlight data for the node.
  Future<Map> getHighlightObjectForTest(
    dom.NodeId nodeId,
  ) async {
    Map parameters = {
      'nodeId': nodeId.toJson(),
    };
    Map result =
        await _client.send('Overlay.getHighlightObjectForTest', parameters);
    return result['highlight'];
  }
}

/// Configuration data for the highlighting of page elements.
class HighlightConfig {
  /// Whether the node info tooltip should be shown (default: false).
  final bool showInfo;

  /// Whether the rulers should be shown (default: false).
  final bool showRulers;

  /// Whether the extension lines from node to the rulers should be shown
  /// (default: false).
  final bool showExtensionLines;

  final bool displayAsMaterial;

  /// The content box highlight fill color (default: transparent).
  final dom.RGBA contentColor;

  /// The padding highlight fill color (default: transparent).
  final dom.RGBA paddingColor;

  /// The border highlight fill color (default: transparent).
  final dom.RGBA borderColor;

  /// The margin highlight fill color (default: transparent).
  final dom.RGBA marginColor;

  /// The event target element highlight fill color (default: transparent).
  final dom.RGBA eventTargetColor;

  /// The shape outside fill color (default: transparent).
  final dom.RGBA shapeColor;

  /// The shape margin fill color (default: transparent).
  final dom.RGBA shapeMarginColor;

  /// Selectors to highlight relevant nodes.
  final String selectorList;

  /// The grid layout color (default: transparent).
  final dom.RGBA cssGridColor;

  HighlightConfig({
    this.showInfo,
    this.showRulers,
    this.showExtensionLines,
    this.displayAsMaterial,
    this.contentColor,
    this.paddingColor,
    this.borderColor,
    this.marginColor,
    this.eventTargetColor,
    this.shapeColor,
    this.shapeMarginColor,
    this.selectorList,
    this.cssGridColor,
  });

  factory HighlightConfig.fromJson(Map json) {
    return new HighlightConfig(
      showInfo: json.containsKey('showInfo') ? json['showInfo'] : null,
      showRulers: json.containsKey('showRulers') ? json['showRulers'] : null,
      showExtensionLines: json.containsKey('showExtensionLines')
          ? json['showExtensionLines']
          : null,
      displayAsMaterial: json.containsKey('displayAsMaterial')
          ? json['displayAsMaterial']
          : null,
      contentColor: json.containsKey('contentColor')
          ? new dom.RGBA.fromJson(json['contentColor'])
          : null,
      paddingColor: json.containsKey('paddingColor')
          ? new dom.RGBA.fromJson(json['paddingColor'])
          : null,
      borderColor: json.containsKey('borderColor')
          ? new dom.RGBA.fromJson(json['borderColor'])
          : null,
      marginColor: json.containsKey('marginColor')
          ? new dom.RGBA.fromJson(json['marginColor'])
          : null,
      eventTargetColor: json.containsKey('eventTargetColor')
          ? new dom.RGBA.fromJson(json['eventTargetColor'])
          : null,
      shapeColor: json.containsKey('shapeColor')
          ? new dom.RGBA.fromJson(json['shapeColor'])
          : null,
      shapeMarginColor: json.containsKey('shapeMarginColor')
          ? new dom.RGBA.fromJson(json['shapeMarginColor'])
          : null,
      selectorList:
          json.containsKey('selectorList') ? json['selectorList'] : null,
      cssGridColor: json.containsKey('cssGridColor')
          ? new dom.RGBA.fromJson(json['cssGridColor'])
          : null,
    );
  }

  Map toJson() {
    Map json = {};
    if (showInfo != null) {
      json['showInfo'] = showInfo;
    }
    if (showRulers != null) {
      json['showRulers'] = showRulers;
    }
    if (showExtensionLines != null) {
      json['showExtensionLines'] = showExtensionLines;
    }
    if (displayAsMaterial != null) {
      json['displayAsMaterial'] = displayAsMaterial;
    }
    if (contentColor != null) {
      json['contentColor'] = contentColor.toJson();
    }
    if (paddingColor != null) {
      json['paddingColor'] = paddingColor.toJson();
    }
    if (borderColor != null) {
      json['borderColor'] = borderColor.toJson();
    }
    if (marginColor != null) {
      json['marginColor'] = marginColor.toJson();
    }
    if (eventTargetColor != null) {
      json['eventTargetColor'] = eventTargetColor.toJson();
    }
    if (shapeColor != null) {
      json['shapeColor'] = shapeColor.toJson();
    }
    if (shapeMarginColor != null) {
      json['shapeMarginColor'] = shapeMarginColor.toJson();
    }
    if (selectorList != null) {
      json['selectorList'] = selectorList;
    }
    if (cssGridColor != null) {
      json['cssGridColor'] = cssGridColor.toJson();
    }
    return json;
  }
}

class InspectMode {
  static const InspectMode searchForNode = const InspectMode._('searchForNode');
  static const InspectMode searchForUAShadowDOM =
      const InspectMode._('searchForUAShadowDOM');
  static const InspectMode none = const InspectMode._('none');
  static const values = const {
    'searchForNode': searchForNode,
    'searchForUAShadowDOM': searchForUAShadowDOM,
    'none': none,
  };

  final String value;

  const InspectMode._(this.value);

  factory InspectMode.fromJson(String value) => values[value];

  String toJson() => value;

  String toString() => value.toString();
}
