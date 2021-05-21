import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

/// Class Log Util
///
/// Created to log a interaction
class LogUtil {
  /// Contains the instance
  ///
  /// Ensure that ``ensureInitialised()`` method is invoked before using it
  static LogUtil instance = LogUtil._();

  /// Constructor to initialise
  LogUtil._();

  Future<void> log(String log, [String logType = 'Normal']) async {
    String appId = GetStorage().read('appId');
    final userId = FirebaseAuth.instance.currentUser.uid;
    // Get the time of logging
    final currTime = DateTime.now().toIso8601String();
    final ref =
        FirebaseFirestore.instance.collection('application/$appId/logs');
    ref.doc().set({
      'log': log,
      'time': currTime,
      'type': logType,
      'userId': userId,
    });
  }
}
/**
 
  /// Contains the instance
  ///
  /// Ensure that ``ensureInitialised()`` method is invoked before using it
  static LogUtil instance;

  /// Holds the content of the log file
  String _logContents;

  /// Holds the fileinstance of log konnex is maintaining
  File _logFile;

  /// Constructor to initialise directory
  LogUtil._(this._logFile) {
    this._logContents = this._logFile.readAsStringSync() ?? '';
  }

  static Future<LogUtil> ensureInitialised() async {
    if (instance != null) return instance;

    Directory root;
    if (Platform.isIOS) {
      root = await path.getApplicationDocumentsDirectory();
    } else {
      root = await path.getExternalStorageDirectory();
    }
    // Get the log Directory
    final logDir = Directory('${root.path}/logs');
    if (!await logDir.exists()) {
      await logDir.create();
    }
    // Get the log file from the directory
    final logFile = File('${logDir.path}/konnex.log');
    // Create if it doesn't exist
    if (!logFile.existsSync()) {
      logFile.createSync();
    }
    // Create the instance
    instance = LogUtil._(logFile);

    return instance;
  }

  /// Writes a log to the logFile
  Future<File> log(String log, [String logType]) async {
    final file = _logFile;
    // Get the time of logging
    final currTime = DateTime.now().toUtc();
    // String to log
    String logStr =
        '${currTime.toString()}::: ${logType ?? 'Normal'} ::: $log\n';
    print(logStr);
    // Add String to the log contents
    this._logContents += logStr;
    // Write the content to the file.
    return file.writeAsString(this._logContents);
  }

  // Uploads logs to the backend server
  Future<void> updateLogs() async {
    try {
      if (this._logContents.isEmpty) return;
      final userId = FirebaseAuth.instance.currentUser.uid;

      final cDate = DateTime.now().toUtc().toString();
      final logFileRef =
          FirebaseStorage.instance.ref('logs/$userId/$cDate.log');
      final uploadTask = logFileRef.putString(this._logContents);
      await uploadTask.whenComplete(() {});
      await this._logFile.writeAsString('');
      print('Logs Updated');
    } catch (e) {
      this.log(e.toString(), 'ERROR');
      print(e.toString());
    }
  }

 */
