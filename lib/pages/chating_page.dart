import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/models/register_user_model.dart';
import 'package:exam/pages/chat_user_available.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../services/chat/auth_services.dart';
import '../services/chat/chat_services.dart';

class ChatingPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatingPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  _ChatingPageState createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage> {
  final TextEditingController _messageController = TextEditingController();
  VideoPlayerController? _videoPlayerController;

  final ChatService _chatService = ChatService();
  final AuthServices _authService = AuthServices();

  bool _isButtonEnabled = false;
  File? imgFile;
  File? video;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _recordVideo() async {
    final picker = ImagePicker();
    XFile? xVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (xVideo != null) {
      setState(() {
        video = File(xVideo.path);
        _videoPlayerController = VideoPlayerController.file(video!)
          ..initialize().then((_) {
            setState(() {}); // Update the state when the video is initialized
          });
        _showImagePreview();
      });
    }
  }

  Future<void> uploadVideo() async {
    String fileNameVideo = const Uuid().v1();
    var ref = FirebaseStorage.instance
        .ref()
        .child('messageVideos')
        .child('$fileNameVideo.mp4');
    var uploadVideo = await ref.putFile(video!);
    String videoUrl = await uploadVideo.ref.getDownloadURL();
    await _chatService.sendMessage(widget.receiverId, videoUrl);
    print('This is the video send Url  $videoUrl');
  }

  Future<void> imagePicker() async {
    ImagePicker picker = ImagePicker();
    // XFile? xFile = await picker.pickVideo(source: ImageSource.gallery);
    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        imgFile = File(xFile.path);
        _showImagePreview(); // Show image preview
      });
    }
  }

  Future<void> _showImagePreview() async {
    if (imgFile != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Preview Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  imgFile!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                TextButton(
                  child: const Text('Send'),
                  onPressed: () {
                    senderMessage();
                    Navigator.of(context).pop(); // Close the preview dialog
                    _onMessageChanged(); // Update button state
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      imgFile = null; // Discard the selected image
                      _onMessageChanged(); // Update button state
                    });
                    Navigator.of(context).pop(); // Close the preview dialog
                  },
                ),
              ],
            ),
          );
        },
      );
    } else if (video != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Preview Video'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_videoPlayerController != null &&
                    _videoPlayerController!.value.isInitialized)
                  AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                const SizedBox(height: 10),
                TextButton(
                  child: const Text('Send'),
                  onPressed: () {
                    senderMessage();
                    Navigator.of(context).pop(); // Close the preview dialog
                    _onMessageChanged(); // Update button state
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      video = null; // Discard the selected video
                      _videoPlayerController?.dispose();
                      _videoPlayerController;
                      _onMessageChanged(); // Update button state
                    });
                    Navigator.of(context).pop(); // Close the preview dialog
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> uploadImage() async {
    String filename = const Uuid().v1();
    var ref = FirebaseStorage.instance
        .ref()
        .child('messageImages')
        .child('$filename.jpg');
    var uploadTask = await ref.putFile(imgFile!);
    String imgUrl = await uploadTask.ref.getDownloadURL();
    await _chatService.sendMessage(widget.receiverId, imgUrl);
    print("This is the img url $imgUrl");
  }

  void _onMessageChanged() {
    setState(() {
      _isButtonEnabled = _messageController.text.isNotEmpty ||
          imgFile != null ||
          video != null;
    });
  }

  Future<void> senderMessage() async {
    if (_messageController.text.isNotEmpty ||
        imgFile != null ||
        video != null) {
      try {
        String message = _messageController.text;
        if (imgFile != null) {
          // Upload image and get its URL
          await uploadImage();
          // Clear the text message if an image is sent
          message = '';
        } else if (video != null) {
          await uploadVideo();
          message = '';
        }
        if (message.isNotEmpty) {
          await _chatService.sendMessage(widget.receiverId, message);
        }
        setState(() {
          imgFile = null; // Reset the image after sending
          _messageController.clear();
          video = null; // Reset the video after sending
        });
        _onMessageChanged(); // Update button state
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          print("FirebaseException: ${e.code}");
          print("Error message: ${e.message}");
          print("Stack trace: ${e.stackTrace}");
        }
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print("Error sending message: $e");
          print("Stack trace: $stackTrace");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users_Chating')
              .doc(widget.receiverId)
              .snapshots(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Text('');
            // }

            // if (snapshot.hasError) {
            //   return const Text('Error');
            // }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text('No occupation');
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final occupation = data['occupation'] as String?;

            return Text(occupation ?? 'Unknown');
          },
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => ChatUserAvailable()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUserEmail()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessage(widget.receiverId, senderID),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return print("object");
          // }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<DocumentSnapshot> docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = docs[index];
                bool showDateHeader = index == 0 ||
                    _shouldShowDateHeader(docs[index], docs[index - 1]);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader) _buildDateHeader(docs[index]),
                    _buildMessageItem(doc),
                  ],
                );
              },
            );
          }
        });
  }
/*
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['receiverId'] != FirebaseAuth.instance.currentUser!.uid;

    Timestamp timestamp = data['timestamp'] as Timestamp;
    String formattedTime = _formatTimestamp(timestamp);

    final alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isCurrentUser ? Colors.green : Colors.black54;
    final textColor = isCurrentUser ? Colors.white : Colors.white;
    final crossAlignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    // Check if the message is a URL
    String message = data['message'] ?? '';
    bool isImage = message.startsWith('https') && !message.startsWith('https://');
    bool isVideo = message.startsWith('https://');

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: crossAlignment,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isImage ? Colors.white : color,
              borderRadius: isCurrentUser
                  ? const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              )
                  : const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: isImage
                ? Image.network(
              message,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            )
                : isVideo
                ? AspectRatio(
              aspectRatio: _videoPlayerController?.value.aspectRatio ?? 16/9,
              child: VideoPlayer(
                VideoPlayerController.network(message)
                  ..initialize().then((_) {
                    setState(() {});
                  }),
              ),
            )
                : Text(
              message,
              style: TextStyle(color: textColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedTime,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }


 */

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        data['receiverId'] != FirebaseAuth.instance.currentUser!.uid;

    Timestamp timestamp = data['timestamp'] as Timestamp;
    String formattedTime = _formatTimestamp(timestamp);

    final alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isCurrentUser ? Colors.green : Colors.black54;
    final textColor = isCurrentUser ? Colors.white : Colors.white;
    final crossAlignment =
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    // Check if the message is a URL
    bool isImage = data['message'] != null &&
        (data['message'] as String).startsWith('http');
    bool isVideo = data['message'] != null &&
        (data['message'] as String).startsWith('https');

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: crossAlignment,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isImage ? Colors.white : color,
              borderRadius: isCurrentUser
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
            ),
            child: isImage
                ?
                // isVideo ? VideoPlayer(_videoPlayerController)
                Image.network(
                    data['message'],
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  )
                : Text(
                    data['message'] ?? 'No message content',
                    style: TextStyle(color: textColor),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedTime,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowDateHeader(
      DocumentSnapshot currentDoc, DocumentSnapshot previousDoc) {
    Timestamp currentTimestamp = currentDoc['timestamp'] as Timestamp;
    Timestamp previousTimestamp = previousDoc['timestamp'] as Timestamp;

    DateTime currentDate = currentTimestamp.toDate();
    DateTime previousDate = previousTimestamp.toDate();

    return currentDate.day != previousDate.day ||
        currentDate.month != previousDate.month ||
        currentDate.year != previousDate.year;
  }

  Widget _buildDateHeader(DocumentSnapshot doc) {
    Timestamp timestamp = doc['timestamp'] as Timestamp;
    DateTime date = timestamp.toDate();
    String formattedDate = _formatDate(date);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            formattedDate,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute}';
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // IconButton(onPressed: (){}, icon:const Icon()),Icons.video_camera_back_outlined
          /*
          there i want to implement the functionality of video player
           */
          // IconButton(
          //   icon:const  Icon(Icons.video_camera_back_outlined),
          //   onPressed:_recordVideo,
          // ),
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: imagePicker,
          ),
          // Expanded(
          //   child: TextField(
          //     controller: _messageController,
          //     keyboardType: TextInputType.multiline,
          //     decoration: const InputDecoration(
          //       //  suffixIcon: IconButton(onPressed: imagePicker, icon:const Icon(Icons.photo)),
          //       hintText: 'Type a message...',
          //       border: OutlineInputBorder(),
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          //     ),
          //     maxLines: null, // Allows multi-line input
          //   ),
          // ),
          Expanded(
            child: Container(
              constraints:const BoxConstraints(
                maxHeight: 70, // Set a fixed height to prevent the TextField from growing indefinitely
              ),
              child: SingleChildScrollView(
                reverse: true, // Ensures the scroll starts from the bottom as you type
                child: TextField(
                  controller: _messageController, // Manage the text with a controller
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // Allows the TextField to take multiple lines
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Type your message here...',
                    contentPadding:const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  style:const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  cursorColor: Colors.blue,
                ),
              ),
            ),
          ),


          IconButton(
            icon: const Icon(Icons.send),
            color: _isButtonEnabled ? Colors.blue : Colors.grey,
            onPressed: _isButtonEnabled ? senderMessage : null,
          ),
        ],
      ),
    );
  }
}
