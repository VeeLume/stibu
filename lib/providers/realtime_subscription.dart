// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:stibu/providers/auth_provider.dart' as _i1;
import 'package:appwrite/appwrite.dart' as _i2;
import 'package:watch_it/watch_it.dart' as _i3;

class RealtimeSubscriptions<T extends _i1.AuthProvider> {
  RealtimeSubscriptions(this._realtime);

  final _i2.Realtime _realtime;

  _i2.RealtimeSubscription? _subscription;

  final Map<String, List<void Function(_i2.RealtimeMessage)>> _listeners = {};

  Set<String> get channels => _listeners.keys.toSet();

  set subscription(_i2.RealtimeSubscription? value) {
    _subscription?.close();
    if (_listeners.isEmpty) {
      return;
    }
    _subscription = value;
    _subscription?.stream.listen((message) {
      final messageChannels = Set.from(message.channels);
      final intersection = messageChannels.intersection(channels);
      for (final channel in intersection) {
        final callbacks = List<void Function(_i2.RealtimeMessage)>.from(
            _listeners[channel] ?? []);
        for (final callback in callbacks) {
          callback(message);
        }
      }
    });
  }

  void subscribe(
    String channelName,
    void Function(_i2.RealtimeMessage) callback,
  ) {
    _listeners
        .putIfAbsent(
          channelName,
          () => [],
        )
        .add(callback);
    subscription = _realtime.subscribe(_listeners.keys.toList());
  }

  void unsubscribe(
    String channelName,
    void Function(_i2.RealtimeMessage) callback,
  ) {
    _listeners[channelName]?.remove(callback);
    _listeners[channelName]?.isEmpty ?? false
        ? _listeners.remove(channelName)
        : null;
    subscription = _realtime.subscribe(_listeners.keys.toList());
  }

  Future<void> build() async {
    final auth = await _i3.di.getAsync<T>();
    auth.addListener(() => auth.isAuthenticated
        ? subscription = _realtime.subscribe(_listeners.keys.toList())
        : subscription = null);
  }
}
