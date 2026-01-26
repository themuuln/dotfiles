import 'dart:convert';

/// Optimized logger for Log Driven Development (LDD).
/// Designed for LLM consumption: high token density, strict structure, no visual fluff.
class AiLogger {
  static final AiLogger _instance = AiLogger._internal();
  factory AiLogger() => _instance;
  AiLogger._internal();

  /// Max length for string values to prevent context window floods.
  static const int _maxStringLength = 256;

  /// Strict format: [Category] Message {metadata}
  void log(
    String category,
    String message, {
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final buffer = StringBuffer();

    // 1. Category
    buffer.write('[$category] ');

    // 2. Message (Sanitized)
    buffer.write(_Sanitizer.clean(message));

    // 3. Metadata & Error Context
    final data = Map<String, dynamic>.from(metadata ?? {});

    if (error != null) {
      data['err'] = error.toString();
    }
    if (stackTrace != null) {
      // Truncate stack trace drastically for token efficiency
      data['stack'] = _truncateStack(stackTrace.toString());
    }

    // 4. Compact JSON Suffix
    if (data.isNotEmpty) {
      buffer.write(' ');
      try {
        // Pre-process data to sanitize values before encoding
        final sanitizedData = _Sanitizer.cleanMap(data);
        buffer.write(jsonEncode(sanitizedData, toEncodable: _safeEncode));
      } catch (e) {
        buffer.write('{_encode_err:"${e.toString()}"}');
      }
    }

    // 5. Output
    // #if DEBUG logic should be handled at the call site or by a wrapper,
    // but in pure Dart, assert/kDebugMode is often used.
    print(buffer.toString());
  }

  /// Handles non-encodable objects safely.
  Object? _safeEncode(Object? object) {
    if (object is DateTime) return object.toIso8601String();
    // For unknown objects, invoke toString() to ensure JSON validity
    return object.toString();
  }

  String _truncateStack(String stack) {
    const maxLines = 3; // Keep it very tight
    final lines = stack.split('\n');
    if (lines.length <= maxLines) return stack;
    return '${lines.take(maxLines).join('\n')}...';
  }
}

/// Utility to strip PII and enforce length limits.
class _Sanitizer {
  // Basic PII Patterns
  static final _emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );
  static final _creditCardRegex = RegExp(r'\b(?:\d[ -]*?){13,16}\b');

  static String clean(String input) {
    if (input.isEmpty) return input;

    var output = input;

    // 1. Mask PII
    if (output.contains('@')) {
      output = output.replaceAllMapped(_emailRegex, (m) => '***@***.com');
    }
    output = output.replaceAll(_creditCardRegex, 'CARD-***');

    // 2. Token Limit / Truncation
    if (output.length > AiLogger._maxStringLength) {
      output = '${output.substring(0, AiLogger._maxStringLength)}[TRUNC]';
    }

    return output;
  }

  static Map<String, dynamic> cleanMap(Map<String, dynamic> map) {
    final clean = <String, dynamic>{};
    for (var entry in map.entries) {
      clean[entry.key] = _cleanValue(entry.value);
    }
    return clean;
  }

  static dynamic _cleanValue(dynamic value) {
    if (value is String) return clean(value);
    if (value is Map<String, dynamic>) return cleanMap(value);
    if (value is List) return value.map(_cleanValue).toList();
    return value;
  }
}
