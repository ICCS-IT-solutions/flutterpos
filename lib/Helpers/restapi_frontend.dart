// ignore_for_file: non_constant_identifier_names

import "package:http/http.dart" as http;
import "package:logger/logger.dart";

// ignore_for_file: camel_case_types

class RestAPI_Frontend
{
	//Triggered by the auth bloc -> handlelogin event handler method.
	Future<dynamic> LoginUser(String user_name, String password) async
	{
		try
		{	
			//Want to make this configurable.
			const api = "http://localhost/pos-api";
			final response = await http.post(
				Uri.parse(api),
				body: {
					"user_name": user_name,
					"password": password
				}
			);
			if(response.statusCode == 200)
			{	
				//All is good.
				//At this point I want to set a token and store it in local storage.
				return response.body;
			}
			else
			{	
				//Return the status code to the caller, so that we can use it to notify the user in the gui.
				return response.statusCode;
			}
		}
		catch(ex)
		{
			Logger().e("Something went wrong during the login process. \n $ex");
			return null;
		}
	}

	Future<dynamic>  LogoffUser() async
	{
		try
		{
			//Log the user off. 
			//Delete their web token.
		}
		catch(ex)
		{
			Logger().e("Something went wrong during the logoff process. \n $ex");
		}
	}
	Future<dynamic> RegisterUser() async
	{
		//This will use our rest API -> register endpoint.
	}

	Future<dynamic> ResetPassword() async
	{
		
	}
}