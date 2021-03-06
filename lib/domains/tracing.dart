import 'dart:async';
import 'package:meta/meta.dart' show required;
import '../src/connection.dart';
import 'io.dart' as io;

class TracingApi {
  final Client _client;

  TracingApi(this._client);

  Stream<BufferUsageEvent> get onBufferUsage => _client.onEvent
      .where((Event event) => event.name == 'Tracing.bufferUsage')
      .map((Event event) => BufferUsageEvent.fromJson(event.parameters));

  /// Contains an bucket of collected trace events. When tracing is stopped collected events will be
  /// send as a sequence of dataCollected events followed by tracingComplete event.
  Stream<List<Map>> get onDataCollected => _client.onEvent
      .where((Event event) => event.name == 'Tracing.dataCollected')
      .map((Event event) =>
          (event.parameters['value'] as List).map((e) => e as Map).toList());

  /// Signals that tracing is stopped and there is no trace buffers pending flush, all data were
  /// delivered via dataCollected events.
  Stream<TracingCompleteEvent> get onTracingComplete => _client.onEvent
      .where((Event event) => event.name == 'Tracing.tracingComplete')
      .map((Event event) => TracingCompleteEvent.fromJson(event.parameters));

  /// Stop trace events collection.
  Future end() async {
    await _client.send('Tracing.end');
  }

  /// Gets supported tracing categories.
  /// Returns: A list of supported tracing categories.
  Future<List<String>> getCategories() async {
    var result = await _client.send('Tracing.getCategories');
    return (result['categories'] as List).map((e) => e as String).toList();
  }

  /// Record a clock sync marker in the trace.
  /// [syncId] The ID of this clock sync marker
  Future recordClockSyncMarker(String syncId) async {
    var parameters = <String, dynamic>{
      'syncId': syncId,
    };
    await _client.send('Tracing.recordClockSyncMarker', parameters);
  }

  /// Request a global memory dump.
  Future<RequestMemoryDumpResult> requestMemoryDump() async {
    var result = await _client.send('Tracing.requestMemoryDump');
    return RequestMemoryDumpResult.fromJson(result);
  }

  /// Start trace events collection.
  /// [bufferUsageReportingInterval] If set, the agent will issue bufferUsage events at this interval, specified in milliseconds
  /// [transferMode] Whether to report trace events as series of dataCollected events or to save trace to a
  /// stream (defaults to `ReportEvents`).
  /// [streamCompression] Compression format to use. This only applies when using `ReturnAsStream`
  /// transfer mode (defaults to `none`)
  Future start(
      {@deprecated String categories,
      @deprecated String options,
      num bufferUsageReportingInterval,
      String transferMode,
      StreamCompression streamCompression,
      TraceConfig traceConfig}) async {
    var parameters = <String, dynamic>{};
    // ignore: deprecated_member_use
    if (categories != null) {
      // ignore: deprecated_member_use
      parameters['categories'] = categories;
    }
    // ignore: deprecated_member_use
    if (options != null) {
      // ignore: deprecated_member_use
      parameters['options'] = options;
    }
    if (bufferUsageReportingInterval != null) {
      parameters['bufferUsageReportingInterval'] = bufferUsageReportingInterval;
    }
    if (transferMode != null) {
      parameters['transferMode'] = transferMode;
    }
    if (streamCompression != null) {
      parameters['streamCompression'] = streamCompression.toJson();
    }
    if (traceConfig != null) {
      parameters['traceConfig'] = traceConfig.toJson();
    }
    await _client.send('Tracing.start', parameters);
  }
}

class BufferUsageEvent {
  /// A number in range [0..1] that indicates the used size of event buffer as a fraction of its
  /// total size.
  final num percentFull;

  /// An approximate number of events in the trace log.
  final num eventCount;

  /// A number in range [0..1] that indicates the used size of event buffer as a fraction of its
  /// total size.
  final num value;

  BufferUsageEvent({this.percentFull, this.eventCount, this.value});

  factory BufferUsageEvent.fromJson(Map<String, dynamic> json) {
    return BufferUsageEvent(
      percentFull: json.containsKey('percentFull') ? json['percentFull'] : null,
      eventCount: json.containsKey('eventCount') ? json['eventCount'] : null,
      value: json.containsKey('value') ? json['value'] : null,
    );
  }
}

class TracingCompleteEvent {
  /// A handle of the stream that holds resulting trace data.
  final io.StreamHandle stream;

  /// Compression format of returned stream.
  final StreamCompression streamCompression;

  TracingCompleteEvent({this.stream, this.streamCompression});

  factory TracingCompleteEvent.fromJson(Map<String, dynamic> json) {
    return TracingCompleteEvent(
      stream: json.containsKey('stream')
          ? io.StreamHandle.fromJson(json['stream'])
          : null,
      streamCompression: json.containsKey('streamCompression')
          ? StreamCompression.fromJson(json['streamCompression'])
          : null,
    );
  }
}

class RequestMemoryDumpResult {
  /// GUID of the resulting global memory dump.
  final String dumpGuid;

  /// True iff the global memory dump succeeded.
  final bool success;

  RequestMemoryDumpResult({@required this.dumpGuid, @required this.success});

  factory RequestMemoryDumpResult.fromJson(Map<String, dynamic> json) {
    return RequestMemoryDumpResult(
      dumpGuid: json['dumpGuid'],
      success: json['success'],
    );
  }
}

/// Configuration for memory dump. Used only when "memory-infra" category is enabled.
class MemoryDumpConfig {
  final Map value;

  MemoryDumpConfig(this.value);

  factory MemoryDumpConfig.fromJson(Map value) => MemoryDumpConfig(value);

  Map toJson() => value;

  @override
  bool operator ==(other) => other is MemoryDumpConfig && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

class TraceConfig {
  /// Controls how the trace buffer stores data.
  final String recordMode;

  /// Turns on JavaScript stack sampling.
  final bool enableSampling;

  /// Turns on system tracing.
  final bool enableSystrace;

  /// Turns on argument filter.
  final bool enableArgumentFilter;

  /// Included category filters.
  final List<String> includedCategories;

  /// Excluded category filters.
  final List<String> excludedCategories;

  /// Configuration to synthesize the delays in tracing.
  final List<String> syntheticDelays;

  /// Configuration for memory dump triggers. Used only when "memory-infra" category is enabled.
  final MemoryDumpConfig memoryDumpConfig;

  TraceConfig(
      {this.recordMode,
      this.enableSampling,
      this.enableSystrace,
      this.enableArgumentFilter,
      this.includedCategories,
      this.excludedCategories,
      this.syntheticDelays,
      this.memoryDumpConfig});

  factory TraceConfig.fromJson(Map<String, dynamic> json) {
    return TraceConfig(
      recordMode: json.containsKey('recordMode') ? json['recordMode'] : null,
      enableSampling:
          json.containsKey('enableSampling') ? json['enableSampling'] : null,
      enableSystrace:
          json.containsKey('enableSystrace') ? json['enableSystrace'] : null,
      enableArgumentFilter: json.containsKey('enableArgumentFilter')
          ? json['enableArgumentFilter']
          : null,
      includedCategories: json.containsKey('includedCategories')
          ? (json['includedCategories'] as List)
              .map((e) => e as String)
              .toList()
          : null,
      excludedCategories: json.containsKey('excludedCategories')
          ? (json['excludedCategories'] as List)
              .map((e) => e as String)
              .toList()
          : null,
      syntheticDelays: json.containsKey('syntheticDelays')
          ? (json['syntheticDelays'] as List).map((e) => e as String).toList()
          : null,
      memoryDumpConfig: json.containsKey('memoryDumpConfig')
          ? MemoryDumpConfig.fromJson(json['memoryDumpConfig'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    if (recordMode != null) {
      json['recordMode'] = recordMode;
    }
    if (enableSampling != null) {
      json['enableSampling'] = enableSampling;
    }
    if (enableSystrace != null) {
      json['enableSystrace'] = enableSystrace;
    }
    if (enableArgumentFilter != null) {
      json['enableArgumentFilter'] = enableArgumentFilter;
    }
    if (includedCategories != null) {
      json['includedCategories'] = includedCategories.map((e) => e).toList();
    }
    if (excludedCategories != null) {
      json['excludedCategories'] = excludedCategories.map((e) => e).toList();
    }
    if (syntheticDelays != null) {
      json['syntheticDelays'] = syntheticDelays.map((e) => e).toList();
    }
    if (memoryDumpConfig != null) {
      json['memoryDumpConfig'] = memoryDumpConfig.toJson();
    }
    return json;
  }
}

/// Compression type to use for traces returned via streams.
class StreamCompression {
  static const StreamCompression none = const StreamCompression._('none');
  static const StreamCompression gzip = const StreamCompression._('gzip');
  static const values = const {
    'none': none,
    'gzip': gzip,
  };

  final String value;

  const StreamCompression._(this.value);

  factory StreamCompression.fromJson(String value) => values[value];

  String toJson() => value;

  @override
  String toString() => value.toString();
}
