import 'package:cloud_firestore/cloud_firestore.dart';

class Batch {
  String id;
  int productId;
  int batchCode;
  Timestamp date;
  int shelfLife;
  bool cookToTemp;
  double hotFillTemp;
  bool lidCheck;
  int unitCount;
  double phPrior;
  double phPost;
  String notes;
  bool ingredientsVerified;
  String initials;
  bool isComplete;

  Batch({
    this.productId,
    this.batchCode,
    this.date,
    this.shelfLife,
    this.cookToTemp,
    this.hotFillTemp,
    this.lidCheck,
    this.unitCount,
    this.phPrior,
    this.phPost,
    this.notes,
    this.ingredientsVerified,
    this.initials,
    this.isComplete,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> _data = {};
    return _data;
  }
}
