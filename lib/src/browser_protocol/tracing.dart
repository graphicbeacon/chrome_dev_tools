import 'dart:async';
import 'package:meta/meta.dart' show required;
import '../connection.dart';
import 'io.dart' as io;

class TracingManager {
  final Session _client;

  TracingManager(this._client);

  final StreamController<List<Map>> _dataCollected =
      new StreamController<List<Map>>.broadcast();

  /// Contains an bucket of collected trace events. When tracing is stopped collected events will be send as a sequence of dataCollected events followed by tracingComplete event.
  Stream<List<Map>> get onDataCollected => _dataCollected.stream;

  final StreamController<io.StreamHandle> _tracingComplete =
      new StreamController<io.StreamHandle>.broadcast();

  /// Signals that tracing is stopped and there is no trace buffers pending flush, all data were delivered via dataCollected events.
  Stream<io.StreamHandle> get onTracingComplete => _tracingComplete.stream;

  final StreamController<BufferUsageResult> _bufferUsage =
      new StreamController<BufferUsageResult>.broadcast();

  Stream<BufferUsageResult> get onBufferUsage => _bufferUsage.stream;

  /// Start trace events collection.
  /// [categories] Category/tag filter
  /// [options] Tracing options
  /// [bufferUsageReportingInterval] If set, the agent will issue bufferUsage events at this interval, specified in milliseconds
  /// [transferMode] Whether to report trace events as series of dataCollected events or to save trace to a stream (defaults to <code>ReportEvents</code>).
  Future start({
    String categories,
    String options,
    num bufferUsageReportingInterval,
    String transferMode,
    TraceConfig traceConfig,
  }) async {
    Map parameters = {};
    if (categories != null) {
      parameters['categories'] = categories;
    }
    if (options != null) {
      parameters['options'] = options;
    }
    if (bufferUsageReportingInterval != null) {
      parameters['bufferUsageReportingInterval'] = bufferUsageReportingInterval;
    }
    if (transferMode != null) {
      parameters['transferMode'] = transferMode;
    }
    if (traceConfig != null) {
      parameters['traceConfig'] = traceConfig.toJson();
    }
    await _client.send('Tracing.start', parameters);
  }

  /// Stop trace events collection.
  Future end() async {
    await _client.send('Tracing.end');
  }

  /// Gets supported tracing categories.
  /// Return: A list of supported tracing categories.
  Future<List<String>> getCategories() async {
    await _client.send('Tracing.getCategories');
  }

  /// Request a global memory dump.
  Future<RequestMemoryDumpResult> requestMemoryDump() async {
    await _client.send('Tracing.requestMemoryDump');
  }

  /// Record a clock sync marker in the trace.
  /// [syncId] The ID of this clock sync marker
  Future recordClockSyncMarker(
    String syncId,
  ) async {
    Map parameters = {
      'syncId': syncId,
    };
    await _client.send('Tracing.recordClockSyncMarker', parameters);
  }
}

class BufferUsageResult {
  /// A number in range [0..1] that indicates the used size of event buffer as a fraction of its total size.
  final num percentFull;

  /// An approximate number of events in the trace log.
  final num eventCount;

  /// A number in range [0..1] that indicates the used size of event buffer as a fraction of its total size.
  final num value;

  BufferUsageResult({
    this.percentFull,
    this.eventCount,
    this.value,
  });

  factory BufferUsageResult.fromJson(Map json) {
    return new BufferUsageResult(
      percentFull: json.containsKey('percentFull') ? json['percentFull'] : null,
      eventCount: json.containsKey('eventCount') ? json['eventCount'] : null,
      value: json.containsKey('value') ? json['value'] : null,
    );
  }
}

class RequestMemoryDumpResult {
  /// GUID of the resulting global memory dump.
  final String dumpGuid;

  /// True iff the global memory dump succeeded.
  final bool success;

  RequestMemoryDumpResult({
    @required this.dumpGuid,
    @required this.success,
  });

  factory RequestMemoryDumpResult.fromJson(Map json) {
    return new RequestMemoryDumpResult(
      dumpGuid: json['dumpGuid'],
      success: json['success'],
    );
  }
}

/// Configuration for memory dump. Used only when "memory-infra" category is enabled.
class MemoryDumpConfig {
  final Map value;

  MemoryDumpConfig(this.value);

  factory MemoryDumpConfig.fromJson(Map value) => new MemoryDumpConfig(value);

  Map toJson() => value;
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

  TraceConfig({
    this.recordMode,
    this.enableSampling,
    this.enableSystrace,
    this.enableArgumentFilter,
    this.includedCategories,
    this.excludedCategories,
    this.syntheticDelays,
    this.memoryDumpConfig,
  });

  factory TraceConfig.fromJson(Map json) {
    return new TraceConfig(
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
          ? new MemoryDumpConfig.fromJson(json['memoryDumpConfig'])
          : null,
    );
  }

  Map toJson() {
    Map json = {};
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