import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/api/parent_api.dart';
import 'package:pragyan_cdc/clients/support/ticket_description_Screen.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import '../../model/support_ticket_model.dart';
import '../../shared/loading.dart';
import 'create_ticket.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  Future<SupportTicketResponse> fetchSupportTickets() async {
    return await Parent().fetchSupportTickets();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green.shade700, Colors.green.shade500],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green.shade700,
          title: const Text(
            'Support Tickets',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            dividerColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Under Process'),
              Tab(text: 'Resolved'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: FutureBuilder<SupportTicketResponse>(
            future: fetchSupportTickets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Loading());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.status != 1) {
                return Center(child: Text('No tickets found.'));
              } else {
                final List<SupportTicket> pendingTickets = snapshot.data!.supportTickets.where((ticket) => ticket.ticketStatusNum == '1').toList();
                final List<SupportTicket> resolvedTickets = snapshot.data!.supportTickets.where((ticket) => ticket.ticketStatusNum == '2').toList();

                return TabBarView(
                  children: [
                    pendingTickets.isEmpty
                        ? Center(child: Text('No tickets found.'))
                        : _buildTicketList(pendingTickets),
                    resolvedTickets.isEmpty
                        ? Center(child: Text('No tickets found.'))
                        : _buildTicketList(resolvedTickets),
                  ],
                );
              }
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
            width: double.infinity,
            text: 'Create Ticket',
            onPressed: () async {
              var status = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateTicketScreen(),
                ),
              );
              if (status == true) {
                setState(() {});
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTicketList(List<SupportTicket> tickets) {
    return ListView.separated(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TicketDescriptionScreen(ticket: ticket),
              ),
            );
          },
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white70,
                border: Border(
                  top: BorderSide(
                    color: Colors.green.shade700,
                    width: 4.0,
                  ),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Title : " + ticket.ticketTitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category : " + ticket.ticketCategory,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Ticket Number : " + ticket.ticketNum),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Ticket Date : " +
                            (ticket.lastCommentDate.isNotEmpty
                                ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(ticket.lastCommentDate))
                                : 'No Date'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Last Response ${ticket.lastCommentBy} : " + ticket.lastComment),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
    );
  }
}
