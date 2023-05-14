import 'dart:convert';
import 'package:haivn/web_config.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'model/model.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

//lấy về bản ghi
httpGet(url, context) async {
  // ignore: unused_local_variable
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  // print("aam ${securityModel.authorization!}");
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }

  var response = await http.get(Uri.parse('$baseUrl$url'), headers: headers);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
    } on FormatException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

void downloadFile(String fileName) {
  html.AnchorElement anchorElement = html.AnchorElement(href: "$baseUrl/api/files/$fileName");
  anchorElement.download = "$baseUrl/api/files/$fileName";
  anchorElement.click();
}

//insert bản ghi
httpPost(url, requestBody, context) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.post(Uri.parse("$baseUrl$url".toString()), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

httpPostNotification(url, requestBody, context) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  if (securityModel.authorization != null) {
    headers["Authorization"] = "aam ${securityModel.authorization!}";
  }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.post(Uri.parse("https://api.aamhr.com.vn$url".toString()), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

httpPostDiariStatus(int ttsId, int statusBefore, int statusAfter, String content, context) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  if (securityModel.authorization != null) {
    headers["Authorization"] = "aam ${securityModel.authorization!}";
  }
  var requestBody = {"ttsId": ttsId, "ttsStatusBeforeId": statusBefore, "ttsStatusAfterId": statusAfter, "content": content};
  var finalRequestBody = json.encode(requestBody);
  var response = await http.post(Uri.parse("$baseUrl/api/tts-nhatky/post/save".toString()), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
  // print("Thành công");
}

//upload các loại file
uploadFile(file, {context}) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  if (file != null) {
    if (file!.files.first.size / (1024 * 1024) > 30) {
    } else {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/api/upload"),
      );
      // request.headers['authorization'] = "aam ${securityModel.authorization!}";
      
      //-----add other fields if needed

      //-----add selected file with request
      request.files.add(http.MultipartFile("file", file!.files.first.readStream!, file.files.first.size, filename: file.files.first.name));
      // ,contentType:file.files.first.
      

      //-------Send request
      var resp = await request.send();

      //------Read response
      String result = await resp.stream.bytesToString();
      var body = json.decode(result);
      print("========================");
      print(body);
      if (body.containsKey("1")) {
        return body['1'];
      }
      return "Chưa có báo cáo, nhấn vào để tải lên.";
    }
  } else {
    return null;
  }
}

//upload các loại file
httpPatch(url, requestBody, context) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  if (securityModel.authorization != null) {
    headers["Authorization"] = securityModel.authorization!;
  }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.patch(Uri.parse('$baseUrl$url'), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  }
  return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
}

//xóa bản ghi
httpDelete(url, context) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var response = await http.delete(Uri.parse('$baseUrl$url'), headers: headers);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

httpDeleteAll(url, requestBody, context) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.delete(Uri.parse('$baseUrl$url'), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

//update bản ghi
httpPut(url, requestBody, context) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.put(Uri.parse('$baseUrl$url'), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
    } on FormatException catch (e) {
      // print(e);
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

//Up file bằng bytes
uploadFileByter(bytes, {context}) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  if (bytes != null) {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/upload"),
    );
    //-----add other fields if needed
    request.headers['authorization'] = "aam ${securityModel.authorization!}";

    //-----add selected file with request
    request.files.add(http.MultipartFile.fromBytes("file", bytes, filename: "Output.xlsx"));

    //-------Send request
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();
    var body = json.decode(result);
    if (body.containsKey("1")) {
      // print(body['1']);
      return body['1'];
    }
    return null;
  } else {
    // print("null");
    return null;
  }
}

//Up file bằng bytes ảnh
uploadFileByte(bytes, {fileName, context}) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  if (bytes != null) {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/upload"),
    );
    //-----add other fields if needed
    request.headers['authorization'] = "aam ${securityModel.authorization!}";

    //-----add selected file with request
    request.files.add(http.MultipartFile.fromBytes("file", bytes, filename: fileName));

    //-------Send request
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();
    var body = json.decode(result);
    if (body.containsKey("1")) {
      // print(body['1']);
      return body['1'];
    }
    return null;
  } else {
    return null;
  }
}

httpPostLichSuTienCu(int ttsId, int orderId, int nominateUser, context, {status, approver, nominateDate, approveDate}) async {
  var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  if (securityModel.authorization != null) {
    headers["Authorization"] = "aam ${securityModel.authorization!}";
  }
  var requestBody = {
    "ttsId": ttsId,
    "orderId": orderId,
    "nominateUser": nominateUser,
    "status": status,
    "approver": approver,
    "nominateDate": nominateDate,
    "approveDate": approveDate,
  };
  var finalRequestBody = json.encode(requestBody);
  var response = await http.post(Uri.parse("$baseUrl/api/tts-lichsu-tiencu/post/save".toString()), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
  // print("Thành công");
}

httpGetCall(url, context) async {
  // print("aam ${securityModel.authorization!}");
  Map<String, String> headers = {'content-type': 'application/json'};
  var token = await http.get(
      Uri.parse('https://public-v1-stg.omicall.com/api/auth?apiKey=3924CD19FB9A1514C96A9FCBA40B5615F02488F6D2C8BCA74D0787431840FE4A'),
      headers: {'content-type': 'application/json'});
  String callToken = json.decode(token.body)['payload']['access_token'];

  headers["Authorization"] = "Bearer $callToken";
  var response = await http.get(Uri.parse('https://public-v1-stg.omicall.com$url'), headers: headers);
  if (response.body != 'Unauthorized') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))['payload']};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {}
  }
}

httpDeleteCall(url, context) async {
  // print("aam ${securityModel.authorization!}");
  Map<String, String> headers = {'content-type': 'application/json'};
  var token = await http.get(
      Uri.parse('https://public-v1-stg.omicall.com/api/auth?apiKey=3924CD19FB9A1514C96A9FCBA40B5615F02488F6D2C8BCA74D0787431840FE4A'),
      headers: {'content-type': 'application/json'});
  String callToken = json.decode(token.body)['payload']['access_token'];

  headers["Authorization"] = "Bearer $callToken";
  var response = await http.delete(Uri.parse('https://public-v1-stg.omicall.com$url'), headers: headers);
  if (response.body != 'Unauthorized') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))['payload']};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {}
  }
}

httpGetForm(url, context) async {
  Map<String, String> headers = {'content-type': 'application/json'};
  var response = await http.get(Uri.parse('$url'), headers: headers);
  return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
}
