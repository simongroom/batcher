import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Batch {
  String batchId;
  String productId;
  int batchCode;
  Timestamp date;
  bool cookToTemp = false;
  double hotFillTemp;
  bool lidCheck = false;
  int unitCount;
  double phPrior;
  double phPost;
  String notes;
  bool ingredientsVerified = false;
  String initials;
  bool isComplete;

  Batch({
    @required this.productId,
    this.batchId,
    this.batchCode,
    this.date,
    this.cookToTemp = false,
    this.hotFillTemp,
    this.lidCheck = false,
    this.unitCount,
    this.phPrior,
    this.phPost,
    this.notes,
    this.ingredientsVerified = false,
    this.initials,
    this.isComplete,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      productId: json['product_id'],
      batchId: json['batch_id'],
      date: json['date'],
      unitCount: json['unit_count'],
      batchCode: json['batch_code'],
      cookToTemp: json['cook_to_temp'] ?? false,
      hotFillTemp: json['hot_fill_temp'],
      lidCheck: json['lid_check'] ?? false,
      ingredientsVerified: json['ingredients_verified'] ?? false,
      phPost: json['ph_post'],
      phPrior: json['ph_prior'],
      initials: json['initials'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> _data = {
      'product_id': productId,
      'batch_id': batchId,
      'date': date,
      'unit_count': unitCount,
      'batch_code': batchCode,
      'cook_to_temp': cookToTemp,
      'hot_fill_temp': hotFillTemp,
      'lid_check': lidCheck,
      'ingredients_verified': ingredientsVerified,
      'ph_post': phPost,
      'ph_prior': phPrior,
      'initials': initials,
      'notes': notes,
    };
    return _data;
  }

  String convertIntToString(int i) {
    String s = i.toString();
    if (i < 10) {
      s = "0" + i.toString();
    }
    return s;
  }

  String buildBatchCode(int productCode) {
    String batchCodeString = convertIntToString(this.batchCode);
    String productCodeString = convertIntToString(productCode);
    return "Batch: $batchCodeString-$productCodeString";
  }
}
