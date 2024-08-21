class SupportTicket {
  final String supportTicketId;
  final String ticketNum;
  final String ticketOwner;
  final String ticketTitle;
  final String ticketCategory;
  final String ticketCategoryNum;
  final String ticketStatus;
  final String ticketStatusNum;
  final String ticketLockby;
  final String ticketLockbyNum;
  final String ticketClosedDate;
  final String ticketCredate;
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
    required this.ticketCategoryNum,
    required this.ticketStatus,
    required this.ticketStatusNum,
    required this.ticketLockby,
    required this.ticketLockbyNum,
    required this.ticketClosedDate,
    required this.ticketCredate,
    required this.lastComment,
    required this.commentImage,
    required this.lastCommentBy,
    required this.lastCommentByNum,
    required this.lastCommentDate,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      supportTicketId: json['support_ticket_id'] ?? '',
      ticketNum: json['ticket_num'] ?? '',
      ticketOwner: json['ticket_owner'] ?? '',
      ticketTitle: json['ticket_title'] ?? '',
      ticketCategory: json['ticket_category'] ?? '',
      ticketCategoryNum: json['ticket_category_num'] ?? '',
      ticketStatus: json['ticket_status'] ?? '',
      ticketStatusNum: json['ticket_status_num'] ?? '',
      ticketLockby: json['ticket_lockby'] ?? '',
      ticketLockbyNum: json['ticket_lockby_num'] ?? '',
      ticketClosedDate: json['ticket_closed_date'] ?? '',
      ticketCredate: json['ticket_credate'] ?? '',
      lastComment: json['last_comment'] ?? '',
      commentImage: json['comment_image'] ?? '',
      lastCommentBy: json['last_comment_by'] ?? '',
      lastCommentByNum: json['last_comment_by_num'] ?? '',
      lastCommentDate: json['last_comment_date'] ?? '',
    );
  }
}

class SupportTicketResponse {
  final int status;
  final String message;
  final String totalTicket;
  final List<SupportTicket> supportTickets;

  SupportTicketResponse({
    required this.status,
    required this.message,
    required this.totalTicket,
    required this.supportTickets,
  });

  factory SupportTicketResponse.fromJson(Map<String, dynamic> json) {
    var list = json['support_ticket'] as List;
    List<SupportTicket> supportTicketsList = list.map((i) => SupportTicket.fromJson(i)).toList();

    return SupportTicketResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      totalTicket: json['total_ticket'] ?? '',
      supportTickets: supportTicketsList,
    );
  }
}


