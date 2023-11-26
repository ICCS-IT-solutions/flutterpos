
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

enum Role
{
  Cashier,
  Manager,
  Administrator,
  Supervisor,
  Inventory_Manager,
  Sales_Representative,
  //User role as a catch-all for users without clearly defined roles:
  User
}

enum UserRight
{
	Can_Process_Sales,
	Can_View_Customer_Info,
	Can_Open_Close_Register,
	Can_Access_Sales_Reports,
	Can_Access_Order_Manager,
	Can_Manage_Inventory,
	Can_Manage_Employees,
	Can_Apply_Discounts,
	Can_Access_System_Settings,
	Can_Add_Remove_Users,
	Can_Backup_Restore_System,
	Can_Configure_Hardware,
	Can_Override_Authorize,
	Can_Access_Detailed_Reports,
	Can_Handle_Refunds_Returns,
	Can_Manage_Inventory_Independently,
	Can_Generate_Inventory_Reports,
	Can_View_Own_Sales_Reports,
	Read_Permission,
	Write_Permission,
}

class User
{
	final String user_name;
	final String? full_name;
	final String? email_address;
	final String password; //Will use this and hash it during registration and login through the api.
	final Role user_role;
	final List<UserRight> user_rights;

	User({required this.user_name, required this.full_name, required this.email_address, required this.password, required this.user_role, required this.user_rights});

	Map<String, dynamic> toDictionary()
	{
		return
		{
			"user_name": user_name,
			"full_name": full_name,
			"email_address": email_address,
			"password": password,
			"user_role": user_role.toString(),
			"user_rights": user_rights
		};
	}

	factory User.fromDictionary(Map<String, dynamic> dictionary)
	{
		return User(
			user_name: dictionary["user_name"],
			full_name: dictionary["full_name"],
			email_address: dictionary["email_address"],
			password: dictionary["password"],
			user_role: dictionary["user_role"],
			user_rights: dictionary["user_rights"],	
		);
	}
	//Copy with: allow to update an existing user's details
	copyWith({String? user_name, String? full_name, String? email_address, String? password, Role? user_role, List<UserRight>? user_rights})
	{
		return User(
			user_name: user_name ?? this.user_name,
			full_name: full_name ?? this.full_name,
			email_address: email_address ?? this.email_address,
			password: password ?? this.password,
			user_role: user_role ?? this.user_role,
			user_rights: user_rights ?? this.user_rights,
		);
	}
}