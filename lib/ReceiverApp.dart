import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ReceiverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Receiver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraReceiverScreen(),
    );
  }
}

class CameraReceiverScreen extends StatefulWidget {
  @override
  _CameraReceiverScreenState createState() => _CameraReceiverScreenState();
}

class _CameraReceiverScreenState extends State<CameraReceiverScreen> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    // Replace with your server's IP address and port
    socket = IO.io('http://192.168.1.4:3000', <String, dynamic>{
      'transports': ['websocket'],
    });
    Uint8List?
        receivedFrame; // Add this variable to hold the received frame data

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Camera Receiver'),
        ),
        body: Center(
          child: receivedFrame != null
              ? Image.memory(receivedFrame!)
              : Text('Waiting for frames...'),
        ),
      );
    }

    socket.onConnect((_) {
      print('Connected to server');

      socket.on('frame', (data) {
        setState(() {
          receivedFrame = data;
        });
      });
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Receiver'),
      ),
      body: Center(
        // Implement an Image widget here to display the received camera frames
        child: Image.network('http://192.168.1.4'),
      ),
    );
  }
}
