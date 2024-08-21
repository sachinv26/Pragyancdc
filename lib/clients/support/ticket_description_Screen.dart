import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/api/parent_api.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'package:pragyan_cdc/model/support_ticket_model.dart';

class TicketDescriptionScreen extends StatefulWidget {
  final SupportTicket ticket;

  const TicketDescriptionScreen({super.key, required this.ticket});

  @override
  State<TicketDescriptionScreen> createState() => _TicketDescriptionScreenState();
}

class _TicketDescriptionScreenState extends State<TicketDescriptionScreen> {
  File? _image;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  late Future<Map<String, dynamic>> _ticketDetailsFuture;

  @override
  void initState() {
    super.initState();
    _ticketDetailsFuture = fetchTicketDetails(int.parse(widget.ticket.supportTicketId));
  }

  Future<Map<String, dynamic>> fetchTicketDetails(int ticketId) async {
    return await Parent().fetchTicketDetails(ticketId);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addComment(int ticketId) async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a comment')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Parent().addCommentToTicket(
        ticketId: ticketId,
        comment: _commentController.text,
        image: _image,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment added successfully')),
      );

      setState(() {
        _commentController.clear();
        _image = null;
        _isLoading = false;
        // Refresh the ticket details
        _ticketDetailsFuture = fetchTicketDetails(ticketId);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        showLeading: true,
        title: 'Ticket Details',
      ),
      body: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _ticketDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Loading());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!['status'] != 1) {
                return Center(child: Text('No ticket details found.'));
              } else {
                final ticketInfo = snapshot.data!['support_ticket_info'];
                final comments = (snapshot.data!['ticket_comments'] as List)
                    .map((comment) => comment as Map<String, dynamic>)
                    .toList();
                final latestCommentBy = comments.isNotEmpty ? comments.last['comment_by'] : '';

                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ticket ID: ${ticketInfo['ticket_num']}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 16.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: comments.length,
                          // Show latest messages at the bottom
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            bool isUserComment = comment['comment_by'] == 'By Me';
                            return Align(
                              alignment: isUserComment ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: isUserComment ? Colors.green.shade100 : Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: isUserComment ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment['comment'],
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    if (comment['comment_image'] != null && comment['comment_image'].isNotEmpty)
                                      SizedBox(
                                        height: 150,
                                        child: Image.network(
                                          'https://dev.cdcconnect.in/${comment['comment_image']}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    Text(
                                      DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(comment['comment_date'])),
                                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (ticketInfo['ticket_status'] != 'Resolved' && latestCommentBy != 'By Me')
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  labelText: 'Add a comment...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.image),
                              onPressed: _pickImage,
                            ),
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () => _addComment(int.parse(widget.ticket.supportTicketId)),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              }
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
