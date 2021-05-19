import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as path;

/// Class Log Util
///
/// Created to log a interaction
class LogUtil {
  /// Contains the instance
  ///
  /// Ensure that ``ensureInitialised()`` method is invoked before using it
  static LogUtil instance;

  /// Holds the content of the log file
  String logContents;

  /// Holds the fileinstance of log konnex is maintaining
  File _logFile;

  /// Constructor to initialise directory
  LogUtil._(this._logFile) {
    this.logContents = this._logFile.readAsStringSync() ?? '';
  }

  static Future<LogUtil> ensureInitialised() async {
    if (instance == null) {
      Directory root;
      if (Platform.isIOS) {
        root = await path.getApplicationDocumentsDirectory();
      } else {
        root = await path.getExternalStorageDirectory();
      }
      // Get the log Directory
      final logDir = Directory('${root.path}/logs');
      // Get the log file from the directory
      final logFile = File('${logDir.path}/konnex.log');
      // Create if it doesn't exist
      if (!logFile.existsSync()) {
        logFile.createSync();
      }
      // Create the instance
      instance = LogUtil._(logFile);
    }
    return instance;
  }

  /// Writes a log to the logFile
  Future<File> log(String log, [String logType]) async {
    final file = _logFile;
    // Get the time of logging
    final currTime = DateTime.now().toUtc();
    // String to log
    String logStr = '${currTime.toString()}: ${logType ?? 'Normal'} : $log\n';
    print(logStr);
    // Add String to the log contents
    this.logContents += logStr;
    // Write the content to the file.
    return file.writeAsString(this.logContents);
  }

  //TODO build this method
  Future<void> updateLogs() {
    throw UnimplementedError();
    // Call REST API for updating user logs
    // If succesful, remove all contents from the file
  }
}
