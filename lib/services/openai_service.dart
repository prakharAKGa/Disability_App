import 'dart:convert';

import 'package:disability_app/secrets/secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;



class OpenAIService {
  final List<Map<String, String>> messages = [];
  final String _apiKey = AppConstants.openAiAPIKey;
  final String _chatApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBW9Batgspxl8iRhLhbeJVAFlOAEPku2Eo';
 
  
  Future<String> isArtPromptAPI(String prompt) async {
   
    try {
      final res = await http.post(
        Uri.parse(_chatApiUrl),
        headers: {
          'Content-Type': 'application/json',
          
        },
        body: jsonEncode({
          "contents": [
            {
              "parts":[
                {
                  "text":prompt
                }
              ]
            },
          ],
         
        }),
      );
      debugPrint(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['candidates'][0]['content']['parts'][0]['text'];
        content = content.trim();
        print(content);
        return content;
        }
        
      }
      catch (e) {
        return e.toString();
      
    }
      return 'An internal error occurred';
    
    } 
    
  }


  
      
