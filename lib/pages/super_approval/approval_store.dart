
import 'package:flutter/material.dart';

class ApprovalStore extends ChangeNotifier {
  ApprovalStore._();

  static final ApprovalStore instance = ApprovalStore._();

  final List<Map<String, String>> decisions = [];

  void addDecision(Map<String, String> decision) {
    decisions.insert(0, decision);
    notifyListeners();
  }
}
