import 'dart:convert';

import 'package:http/http.dart' as http;

class SMS {
  // Resgister Phone
  register(String phone) async {
    String URL = "https://stark-cliffs-36027.herokuapp.com/?number=$phone";

    var client = http.Client();
    try {
      var url = Uri.parse(URL);
      var response = await client.get(url);
      if (response.statusCode == 200) {
        print(response);
      }
    } finally {
      client.close();
    }
  }

  // Check Phone Number
  check(String phone) async {
    String URL = "https://stark-cliffs-36027.herokuapp.com/check";

    var client = http.Client();
    try {
      var url = Uri.parse(URL);
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var j = json.decode(response.body);
        for (var i = 0; i < j["data"].length; i++) {
          if (j["data"][i]["PhoneNumber"] == "+" + phone) {
            if (j["data"][i]["Status"] == "Verified") {
              print("true");
              return true;
            }
          }
        }
        print("false");
        return false;
      }
    } finally {
      client.close();
    }
  }

  // Verify Phone
  verify(String phone, String otp) async {
    String URL =
        "https://stark-cliffs-36027.herokuapp.com/verify/?number=$phone&otp=$otp";

    var client = http.Client();
    try {
      var url = Uri.parse(URL);
      var response = await client.get(url);
      if (response.statusCode == 200) {
        print(response);
      }
    } finally {
      client.close();
    }
  }

  // Publish SMS
  publish(String phone, String message) async {
    // String URL =
    // "https://stark-cliffs-36027.herokuapp.com/publish/?message=$message&number=$phone";

    String URL =
        "http://bhashsms.com/api/sendmsg.php?user=ychatwani&pass=123456&sender=CHTEDU&phone=$phone&text=$message&priority=ndnd&stype=normal";
    var client = http.Client();
    try {
      var url = Uri.parse(URL);
      var response = await client.get(url);
      if (response.statusCode == 200) {
        print("Sent");
        print(response.body);
      }
    } finally {
      client.close();
    }
  }
}
