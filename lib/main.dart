import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:dialogflow_gcp_chatbot/messages.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artificial Machine Bot',
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];
  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Artificial Machine Bot'),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: MessagesScreen(messages: messages),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: Colors.deepPurple,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                            cursorColor: Colors.deepPurple,
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.send, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print("Message is Empty");
    } else {
      //Handling User Message
      setState(() {
        addMessage(
            Message(
              text: DialogText(text: [text]),
            ),
            true);
      });
      //Handling DialogFlutter Message
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(
          text: TextInput(text: text),
        ),
      );
      if (response.message == null) return;
      //Handling DialogFlutter Message
      setState(() {
        addMessage(response.message!);
      });
    }
  }

//Both are using this addMessage to handle both message and boolean value inside my messages list
  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}




// import 'package:flutter/material.dart';

// void main() {
//   runApp(ArtificialMachineBotApp());
// }

// class ArtificialMachineBotApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Artificial Machine Bot',
//       theme: ThemeData(
//         primaryColor: Colors.deepPurple,
//         accentColor: Colors.white,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ChatScreen(),
//     );
//   }
// }

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController _controller = TextEditingController();
//   List<String> messages = [];

//   void sendMessage(String message) {
//     if (message.isNotEmpty) {
//       setState(() {
//         messages.add(message);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Artificial Machine Bot'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: MessagesScreen(messages: messages),
//           ),
//           _buildInputArea(),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: EdgeInsets.all(8),
//       color: Colors.deepPurple,
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: TextField(
//                   controller: _controller,
//                   decoration: InputDecoration(
//                     hintText: 'Type your message...',
//                     border: InputBorder.none,
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 8),
//           GestureDetector(
//             onTap: () {
//               sendMessage(_controller.text);
//               _controller.clear();
//             },
//             child: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.white,
//               child: Icon(Icons.send, color: Colors.deepPurple),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessagesScreen extends StatelessWidget {
//   final List<String> messages;

//   MessagesScreen({required this.messages});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       itemCount: messages.length,
//       reverse: true,
//       itemBuilder: (context, index) {
//         return _buildMessage(messages[index]);
//       },
//     );
//   }

//   Widget _buildMessage(String message) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 8),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//             bottomRight: Radius.circular(20),
//           ),
//         ),
//         child: Text(message),
//       ),
//     );
//   }
// }
