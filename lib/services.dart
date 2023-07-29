import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAI {
  final List<Map<String, String>> conversation=[];
  // Future<String> detemineAPI(String prompt) async {
  //   try {
  //     final response = await http.post(
  //         Uri.parse('https://open-ai21.p.rapidapi.com/conversation'),
  //         headers: {
  //           "content-type": "application/json",
  //           "X-RapidAPI-Key": "09bdfa1c81msh16ec14357af83c7p1b1cf2jsn4c029b3d75cd",
  //           "X-RapidAPI-Host": "open-ai21.p.rapidapi.com",
  //         },
  //         body: jsonEncode({
  //           "messages": [
  //             {
  //               "role": "user",
  //               "content": "Does this message asks to generate some kind of picture, image, art or something similar? $prompt. Reply with a simple yes or no.",
  //             }
  //           ],
  //           "max_token": 1000,
  //           "temperature": 1,
  //           "web_access": false
  //         }),
  //     );
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       String content = jsonDecode(response.body)['ChatGPT'];
  //       content = content.trim();
  //       switch(content){
  //         case 'yes':
  //         case 'YES':
  //         case 'yes.':
  //         case 'YES.':
  //         case 'Yes':
  //         case 'Yes.':
  //           final response = await DallE(prompt);
  //           return response;
  //         default:
  //           final response = await ChatGpt(prompt);
  //           return response;
  //       }
  //     }
  //     return ("Some Error");
  //   }
  //   catch (e) {
  //     return (e.toString());
  //   }
  // }

  Future<String> DallE(String prompt) async{
    conversation.add({
      'role':'user',
      'content':prompt,
    });
    try {
      final response = await http.post(
        Uri.parse('https://open-ai21.p.rapidapi.com/dalle'),
        headers: {
          "content-type": "application/json",
          "X-RapidAPI-Key": "09bdfa1c81msh16ec14357af83c7p1b1cf2jsn4c029b3d75cd",
          "X-RapidAPI-Host": "open-ai21.p.rapidapi.com",
        },
        body: jsonEncode({
          "text": prompt,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        String url = jsonDecode(response.body)['url'];
        url = url.trim();
        conversation.add({
          'role': 'assistant',
          'content': url,
        });
        return url;
      }
      return ("Some Error");
    }
    catch (e) {
      return (e.toString());
    }
  }

  Future<String>ChatGpt(String prompt) async{
    conversation.add({
      'role':'user',
      'content':prompt,
    });
    try {
      final response = await http.post(
        Uri.parse('https://open-ai21.p.rapidapi.com/conversation'),
        headers: {
          "content-type": "application/json",
          "X-RapidAPI-Key": "09bdfa1c81msh16ec14357af83c7p1b1cf2jsn4c029b3d75cd",
          "X-RapidAPI-Host": "open-ai21.p.rapidapi.com",
        },
        body: jsonEncode({
          "messages": conversation,
          "max_token": 1000,
          "temperature": 1,
          "web_access": false
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        String content = jsonDecode(response.body)['ChatGPT'];
        content = content.trim();
        conversation.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return ("Some Error");
    }
    catch (e) {
      return (e.toString());
    }
  }
}
