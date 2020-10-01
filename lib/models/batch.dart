import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Batch {
  String id;
  String productId;
  int batchCode;
  Timestamp date;
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
    @required this.productId,
    this.batchCode,
    this.date,
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
    return Batch(
      productId: json['product_id'],
      date: json['date'],
      unitCount: json['unit_count'],
      batchCode: json['batch_code'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> _data = {};
    return _data;
  }
}
