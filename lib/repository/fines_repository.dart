import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:klubhuset/helpers/api_config.dart';
import 'package:klubhuset/model/create_fine_type_command.dart';
import 'package:klubhuset/model/create_user_fine_command.dart';
import 'package:klubhuset/model/create_user_fines_command.dart';
import 'package:klubhuset/model/deposit_amount_to_fine_box_command.dart';
import 'package:klubhuset/model/fine_box_details.dart';
import 'package:klubhuset/model/fine_type_details.dart';

class FinesRepository {
  static Future<List<FineTypeDetails>> getFineTypes() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${ApiConfig.baseUrl}/fine/types');

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fine types');
    }

    Iterable json = jsonDecode(response.body)['body'];

    return List<FineTypeDetails>.from(
        json.map((content) => FineTypeDetails.fromJson(content)));
  }

  static Future<FineBoxDetails> getFineBox() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${ApiConfig.baseUrl}/fine/fine_box');

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fine box');
    }

    var json = jsonDecode(response.body)['body'];

    return FineBoxDetails.fromJson(json);
  }

  static Future<List<int>> addFineForUsers(
      List<CreateUserFineCommand> createUserFineCommands) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${ApiConfig.baseUrl}/fine/users');

    var createUserFinesCommand = CreateUserFinesCommand(createUserFineCommands);

    var response = await http.post(url, body: createUserFinesCommand.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to add fine for user');
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    Iterable json = responseBody['body'];

    return json.map((content) => content as int).toList();
  }

  static Future<bool> depositAmountToFineBox(
      int fineBoxId, String amountToDeposit, List<int> userFineIds) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${ApiConfig.baseUrl}/fine/fine_box/deposit');

    var depositAmountToFineBoxCommand = DepositAmountToFineBoxCommand(
        fineBoxId: fineBoxId.toString(),
        amountToDeposit: amountToDeposit,
        userFineIds: userFineIds.map((x) => x.toString()).toList());

    var response =
        await http.post(url, body: depositAmountToFineBoxCommand.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to deposit amount to fine box');
    }

    return true;
  }

  static Future<bool> createFineType(String title, String defaultAmount) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${ApiConfig.baseUrl}/fine/type');

    var createFineTypeCommmand =
        CreateFineTypeCommand(title: title, defaultAmount: defaultAmount);

    var response = await http.post(url, body: createFineTypeCommmand.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to create fine type');
    }

    return true;
  }
}
