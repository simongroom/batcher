import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Batch {
  final CollectionReference batches =
      FirebaseFirestore.instance.collection('batches');

  String batchId;
  String productId;
  int batchNumber;
  String batchCode;
  Timestamp date;
  bool cookToTemp = false;
  double hotFillTemp;
  bool lidCheck = false;
  int unitCount = 0;
  int halfGallonCount = 0;
  int gallonCount = 0;
  int pailCount = 0;
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
    this.batchNumber,
    this.date,
    this.cookToTemp = false,
    this.hotFillTemp,
    this.lidCheck = false,
    this.unitCount = 0,
    this.halfGallonCount = 0,
    this.gallonCount = 0,
    this.pailCount = 0,
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
      unitCount: json['unit_count'] ?? 0,
      halfGallonCount: json['half_gallon_count'] ?? 0,
      gallonCount: json['gallon_count'] ?? 0,
      pailCount: json['pail_count'] ?? 0,
      batchCode: json['batch_code'],
      batchNumber: json['batch_number'],
      cookToTemp: json['cook_to_temp'] ?? false,
      hotFillTemp: json['hot_fill_temp'] != null
          ? json['hot_fill_temp'].toDouble()
          : null,
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
      'half_gallon_count': halfGallonCount,
      'gallon_count': gallonCount,
      'pail_count': pailCount,
      'batch_code': batchCode,
      'batch_number': batchNumber,
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
    if (batchCode != null) {
      return batchCode;
    } else {
      String batchCodeString = convertIntToString(batchNumber);
      String productCodeString = convertIntToString(productCode);
      return "$batchCodeString-$productCodeString";
    }
  }

  Future save() async {
    return batches.doc(batchId).set(toJson());
  }
}
