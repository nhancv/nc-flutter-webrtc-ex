import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef void OnMessageCallback(String tag, dynamic msg);
typedef void OnCloseCallback(int code, String reason);
typedef void OnOpenCallback();

const CLIENT_ID_EVENT = 'client-id-event';
const OFFER_EVENT = 'offer-event';
const ANSWER_EVENT = 'answer-event';
const ICE_CANDIDATE_EVENT = 'ice-candidate-event';

class SimpleWebSocket {
  String url;
  IO.Socket socket;
  OnOpenCallback onOpen;
  OnMessageCallback onMessage;
  OnCloseCallback onClose;

  SimpleWebSocket(this.url);

  connect() async {
    try {
      socket = IO.io(url, <String, dynamic>{
        'transports': ['websocket']
      });
      // Dart client
      socket.on('connect', (_) {
        print('connected');
        onOpen();
      });
      socket.on(CLIENT_ID_EVENT, (data) {
        onMessage(CLIENT_ID_EVENT, data);
      });
      socket.on(OFFER_EVENT, (data) {
        onMessage(OFFER_EVENT, data);
      });
      socket.on(ANSWER_EVENT, (data) {
        onMessage(ANSWER_EVENT, data);
      });
      socket.on(ICE_CANDIDATE_EVENT, (data) {
        onMessage(ICE_CANDIDATE_EVENT, data);
      });
      socket.on('exception', (e) => print('Exception: $e'));
      socket.on('connect_error', (e) => print('Connect error: $e'));
      socket.on('disconnect', (e) {
        print('disconnect');
        onClose(0, e);
      });
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      this.onClose(500, e.toString());
    }
  }

  send(event, data) {
    if (socket != null) {
      socket.emit(event, data);
      print('send: $event - $data');
    }
  }

  close() {
    if (socket != null) socket.close();
  }
}
