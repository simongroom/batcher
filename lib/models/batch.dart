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
  double batchMultiple;
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

  Batch({
    @required this.productId,
    this.batchId,
    this.batchCode,
    this.batchNumber,
    this.date,
    this.batchMultiple = 1.0,
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
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      productId: json['product_id'],
      batchId: json['batch_id'],
      date: json['date'],
      batchMultiple: json['batch_multiple'] != null
          ? json['batch_multiple'].toDouble()
          : null,
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
      phPost: json['ph_post'] != null ? json['ph_post'].toDouble() : null,
      phPrior: json['ph_prior'] != null ? json['ph_prior'].toDouble() : null,
      initials: json['initials'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson(bool isColdFill) {
    Map<String, dynamic> _data = {
      'product_id': productId,
      'batch_id': batchId,
      'date': date,
      'batch_multiple': batchMultiple,
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
      'is_complete': isComplete(isColdFill),
    };
    return _data;
  }

  Future save(bool isColdFill) async {
    return batches.doc(batchId).set(toJson(isColdFill));
  }

  bool isComplete(bool isColdFill) {
    if (unitCount == 0 &&
        halfGallonCount == 0 &&
        gallonCount == 0 &&
        pailCount == 0) {
      return false;
    }
    if (initials?.isEmpty ?? true) {
      return false;
    }
    if (!lidCheck || !ingredientsVerified) {
      return false;
    }
    if (phPost == null || batchMultiple == null) {
      return false;
    }
    if (isColdFill) {
      return phPrior != null;
    } else {
      return cookToTemp && hotFillTemp != null;
    }
  }
}
