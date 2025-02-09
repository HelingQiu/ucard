class MessageModel {
  int messageId;
  int type;
  int is_read;
  DateTime created_at;
  DateTime updated_at;
  String content;
  String title;
  String brief_content;

  MessageModel(this.messageId, this.type, this.is_read, this.created_at,
      this.updated_at, this.content, this.title, this.brief_content);

  factory MessageModel.parse(Map<String, dynamic> data) {
    int couponId = 0;
    var cid = data["id"];
    if (cid != null && cid is int) {
      couponId = cid;
    }

    int type = 0;
    var t = data["type"];
    if (t != null && t is int) {
      type = t;
    }

    int is_read = 0;
    var ct = data["is_read"];
    if (ct != null && ct is int) {
      is_read = ct;
    }

    DateTime createTime = DateTime.now();
    int ca = data["created_at"];
    if (ca != null && ca != 0) {
      createTime = DateTime.fromMillisecondsSinceEpoch(ca * 1000);
    }

    DateTime updateTime = DateTime.now();
    int ua = data["updated_at"];
    if (ua != null && ua != 0) {
      updateTime = DateTime.fromMillisecondsSinceEpoch(ua * 1000);
    }

    String content = data["content"] ?? "";
    String title = data["title"] ?? "";
    String brief_content = data["brief_content"] ?? "";

    return MessageModel(couponId, type, is_read, createTime, updateTime,
        content, title, brief_content);
  }
}
