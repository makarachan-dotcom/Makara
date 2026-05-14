import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service that connects a Telegram Bot to Firebase Cloud Messaging (FCM)
/// for admin broadcast notifications.
///
/// Architecture:
/// 1. Telegram Bot receives admin commands via webhook/polling
/// 2. Bot backend sends HTTP request to FCM API
/// 3. FCM delivers push notification to all subscribed app users
///
/// The app subscribes to a topic (e.g., "all_users") on startup.
/// The admin sends a message via Telegram Bot, which triggers
/// an FCM topic message to all subscribed devices.
class FcmTelegramService {
  final String _fcmServerKey;
  final String _telegramBotToken;
  static const String _fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  static const String _telegramApiBase = 'https://api.telegram.org/bot';
  static const String defaultTopic = 'all_users';

  FcmTelegramService({
    required String fcmServerKey,
    required String telegramBotToken,
  })  : _fcmServerKey = fcmServerKey,
        _telegramBotToken = telegramBotToken;

  /// Send a broadcast notification to all app users via FCM topic
  Future<bool> sendBroadcastNotification({
    required String title,
    required String body,
    String topic = defaultTopic,
    Map<String, String>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_fcmServerKey',
        },
        body: jsonEncode({
          'to': '/topics/$topic',
          'notification': {
            'title': title,
            'body': body,
            'sound': 'default',
          },
          if (data != null) 'data': data,
          'priority': 'high',
        }),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Process incoming Telegram message from admin
  /// Expected command format: /broadcast Title | Body
  Future<void> processTelegramUpdate(Map<String, dynamic> update) async {
    final message = update['message'] as Map<String, dynamic>?;
    if (message == null) return;

    final text = message['text'] as String? ?? '';
    final chatId = message['chat']?['id'];

    if (text.startsWith('/broadcast ')) {
      final content = text.substring('/broadcast '.length);
      final parts = content.split('|');

      if (parts.length >= 2) {
        final title = parts[0].trim();
        final body = parts.sublist(1).join('|').trim();

        final success = await sendBroadcastNotification(
          title: title,
          body: body,
        );

        await _sendTelegramReply(
          chatId: chatId,
          text: success
              ? '✅ ការជូនដំណឹងត្រូវបានផ្ញើទៅអ្នកប្រើប្រាស់ទាំងអស់'
              : '❌ មានកំហុសក្នុងការផ្ញើការជូនដំណឹង',
        );
      } else {
        await _sendTelegramReply(
          chatId: chatId,
          text: 'ទម្រង់: /broadcast ចំណងជើង | អត្ថបទ',
        );
      }
    }
  }

  /// Send a reply message back to the Telegram admin
  Future<void> _sendTelegramReply({
    required dynamic chatId,
    required String text,
  }) async {
    try {
      await http.post(
        Uri.parse('$_telegramApiBase$_telegramBotToken/sendMessage'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': chatId,
          'text': text,
        }),
      );
    } catch (_) {
      // Silently fail for Telegram replies
    }
  }

  /// Set up Telegram webhook for receiving admin commands
  Future<bool> setWebhook(String webhookUrl) async {
    try {
      final response = await http.post(
        Uri.parse('$_telegramApiBase$_telegramBotToken/setWebhook'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': webhookUrl}),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

/// Server-side handler example (Cloud Function / backend endpoint)
/// This would be deployed as a Firebase Cloud Function or similar backend
///
/// ```dart
/// // Cloud Function pseudo-code:
/// exports.telegramWebhook = functions.https.onRequest((req, res) async {
///   final service = FcmTelegramService(
///     fcmServerKey: process.env.FCM_SERVER_KEY,
///     telegramBotToken: process.env.TELEGRAM_BOT_TOKEN,
///   );
///   await service.processTelegramUpdate(req.body);
///   res.status(200).send('OK');
/// });
/// ```
