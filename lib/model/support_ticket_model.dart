class SupportTicketResponse {
  final int status;
  final String message;
  final List<SupportTicket> supportTickets;

  SupportTicketResponse({
    required this.status,
    required this.message,
    required this.supportTickets,
  });

  factory SupportTicketResponse.fromJson(Map<String, dynamic> json) {
    return SupportTicketResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      supportTickets: json['support_tickets'] != null
          ? List<SupportTicket>.from(json['support_tickets'].map((x) => SupportTicket.fromJson(x)))
          : [],
    );
  }
}

class SupportTicket {
  final String supportTicketId;
  final String ticketNum;
  final String ticketOwner;
  final String ticketTitle;
  final String ticketCategory;
  final String ticketStatus;
  final String ticketStatusNum;
  final String ticketLockBy;
  final String ticketLockByNum;
  final String? ticketClosedDate;
  final String ticketCreDate;
  final String lastComment;
  final String commentImage;
  final String lastCommentBy;
  final String lastCommentByNum;
  final String lastCommentDate;

  SupportTicket({
    required this.supportTicketId,
    required this.ticketNum,
    required this.ticketOwner,
    required this.ticketTitle,
    required this.ticketCategory,
    required this.ticketStatus,
    required this.ticketStatusNum,
    required this.ticketLockBy,
    required this.ticketLockByNum,
    this.ticketClosedDate,
    required this.ticketCreDate,
    required this.lastComment,
    required this.commentImage,
    required this.lastCommentBy,
    required this.lastCommentByNum,
    required this.lastCommentDate,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      supportTicketId: json['support_ticket_id'],
      ticketNum: json['ticket_num'],
      ticketOwner: json['ticket_owner'],
      ticketTitle: json['ticket_title'],
      ticketCategory: json['ticket_category'],
      ticketStatus: json['ticket_status'],
      ticketStatusNum: json['ticket_status_num'],
      ticketLockBy: json['ticket_lockby'],
      ticketLockByNum: json['ticket_lockby_num'],
      ticketClosedDate: json['ticket_closed_date'],
      ticketCreDate: json['ticket_credate'],
      lastComment: json['last_comment'],
      commentImage: json['comment_image'],
      lastCommentBy: json['last_comment_by'],
      lastCommentByNum: json['last_comment_by_num'],
      lastCommentDate: json['last_comment_date']?? '',
    );
  }
}