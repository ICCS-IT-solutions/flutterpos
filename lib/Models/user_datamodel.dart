//This filename is user_datamodel, not userdata_model. 
//If I was building this in C# it would be User_Datamodel.cs
//Userdata_Model.cs would refer to a datamodel for userdata, not the datamodel for a user's profile.
//Using the filename 'UserDataModel' is downright confusing, and dof.


// ignore_for_file: constant_identifier_names, non_constant_identifier_names

// Listen up those of you who like to force the same format and style on everyone: 
// What do you lot think we are? Robots? Not me! I'm made of 100 percent flesh, bones and blood. 
// I was CREATED by the almighty Lord God above!
// Sod off, code Nazis.

// Embrace diversity, the way we were meant to, and that means embrace your individuality!

// My code, my rules, my style. Each one to his own.

//What do we need for a PoS system user other than a username and password? Rights, and roles!

//The roles should mirror their real world duties
import 'package:flutterpos/Auth/AuthManager.dart';

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

//Should the user's hashed password and salt be kept here as variables, or does one retrieve that from the database on login?
class UserDataModel
{
	final String userName;
	final String? fullName;
	final String password;
	final Role userRole;
	final String? hashedPassword;
	final String? salt;

	final List<UserRight> userRights;

	UserDataModel({required this.userName, required this.fullName, required this.password, this.hashedPassword, this.salt, required this.userRole, required this.userRights});

	Map<String, dynamic> toDictionary()
	{
		final salt = AuthManager().GenerateSalt();
		final dictionary = 
		{
			"userName": userName,
			"fullName": fullName,
			"password": password,
			"hashedPassword": AuthManager().HashPassword(password, salt),
			"salt": salt,
			"userRole": MapRoleToRoleName(userRole),
		};

		final userRights = UserRightsHandler().GetUserRights(userRole);
		const userRightValues = UserRight.values;

		for (final userRight in userRightValues)
		{
			final rightString = userRight.toString().split(".").last;
			dictionary[rightString] = 
			userRights.contains(userRight) ? 'Y' : 'N';
		}
	return dictionary;
  	}

	factory UserDataModel.fromDictionary(Map<String,dynamic> dictionary)
	{
		return UserDataModel(
			userName: dictionary["userName"],
			fullName: dictionary["fullName"], 
			password: dictionary["password"],
			hashedPassword: dictionary["hashedPassword"],
			salt: dictionary["salt"], 
			userRole: MapRoleNameToRole(dictionary["userRole"]),

			//It sucks balls, but I have to do it this way :(
			//I am not sure of a working alternative because I need to assign the enum values 
			//based on the incoming string names from the dataset returned from a query. 
			userRights: [
				if(dictionary["can_process_sales"] == 'Y') UserRight.Can_Process_Sales,
				if(dictionary["can_view_customer_info"] == 'Y') UserRight.Can_View_Customer_Info,
				if(dictionary["can_open_close_register"] == 'Y') UserRight.Can_Open_Close_Register,
				if(dictionary["can_access_sales_reports"] == 'Y') UserRight.Can_Access_Sales_Reports,
				if(dictionary["can_manage_inventory"] == 'Y') UserRight.Can_Manage_Inventory,
				if(dictionary["can_manage_employees"] == 'Y') UserRight.Can_Manage_Employees,
				if(dictionary["can_apply_discounts"] == 'Y') UserRight.Can_Apply_Discounts,
				if(dictionary["can_access_system_settings"] == 'Y') UserRight.Can_Access_System_Settings,
				if(dictionary["can_add_remove_users"] == 'Y') UserRight.Can_Add_Remove_Users,
				if(dictionary["can_backup_restore_system"] == 'Y') UserRight.Can_Backup_Restore_System,
				if(dictionary["can_configure_hardware"] == 'Y') UserRight.Can_Configure_Hardware,
				if(dictionary["can_override_authorize"] == 'Y') UserRight.Can_Override_Authorize,
				if(dictionary["can_access_detailed_reports"] == 'Y') UserRight.Can_Access_Detailed_Reports,
				if(dictionary["can_handle_refunds_returns"] == 'Y') UserRight.Can_Handle_Refunds_Returns,
				if(dictionary["can_manage_inventory_independently"] == 'Y') UserRight.Can_Manage_Inventory_Independently,
				if(dictionary["can_generate_inventory_reports"] == 'Y') UserRight.Can_Generate_Inventory_Reports,
				if(dictionary["can_view_own_sales_reports"] == 'Y') UserRight.Can_View_Own_Sales_Reports,
				if(dictionary["read_permission"] == 'Y') UserRight.Read_Permission,
				if(dictionary["write_permission"] == 'Y') UserRight.Write_Permission,
			]
		);
	}
}

Role MapRoleNameToRole(String roleString)
{
	switch(roleString)
	{
		case "Cashier":
			return Role.Cashier;
		case "Manager":
			return Role.Manager;
		case "Administrator":
			return Role.Administrator;
		case "Supervisor":
			return Role.Supervisor;
		case "Inventory_Manager":
			return Role.Inventory_Manager;
		case "Sales_Representative":
			return Role.Sales_Representative;
		default:
			return Role.User;
	}
}

String MapRoleToRoleName(Role role)
{
	switch(role)
	{
		case Role.Cashier:
			return "Cashier";
		case Role.Manager:
			return "Manager";
		case Role.Administrator:
			return "Administrator";
		case Role.Supervisor:
			return "Supervisor";
		case Role.Inventory_Manager:
			return "Inventory_Manager";
		case Role.Sales_Representative:
			return "Sales_Representative";
		default:
			return "User";
	}
}

//Rights handler class
class UserRightsHandler
{
	List<UserRight> GetUserRights(Role role)
	{
		switch(role)
		{
		case Role.Cashier:
			return CashierRights();
		case Role.Manager:
			return ManagerRights();
		case Role.Administrator:
			return AdministratorRights();
		case Role.Supervisor:
			return SupervisorRights();
		case Role.Inventory_Manager:
			return InventoryManagerRights();
		case Role.Sales_Representative:
			return SalesRepresentativeRights();
		case Role.User:
		//Users dont yet have any rights to the system.
			return [];
		}
	}

	List<UserRight> AdministratorRights()
	{
		//All these rights apply to administrators, in IT circles they are often referred to as the superuser:
		return [
			UserRight.Can_Process_Sales,
			UserRight.Can_View_Customer_Info,
			UserRight.Can_Open_Close_Register,
			UserRight.Can_Access_Sales_Reports,
			UserRight.Can_Manage_Inventory,
			UserRight.Can_Manage_Employees,
			UserRight.Can_Apply_Discounts,
			UserRight.Can_Access_System_Settings,
			UserRight.Can_Add_Remove_Users,
			UserRight.Can_Backup_Restore_System,
			UserRight.Can_Configure_Hardware,
			UserRight.Can_Override_Authorize,
			UserRight.Can_Access_Detailed_Reports,
			UserRight.Can_Handle_Refunds_Returns,
			UserRight.Can_Manage_Inventory_Independently,
			UserRight.Can_Generate_Inventory_Reports,
			UserRight.Can_View_Own_Sales_Reports,
			UserRight.Read_Permission,
			UserRight.Write_Permission,
		];
	}

	List<UserRight> ManagerRights()
	{
		return[
			UserRight.Can_Process_Sales,
			UserRight.Can_View_Customer_Info,
			UserRight.Can_Open_Close_Register,
			UserRight.Can_Access_Sales_Reports,
			UserRight.Can_Manage_Inventory,
			UserRight.Can_Manage_Employees,
			UserRight.Can_Apply_Discounts,
		];
	}

	List<UserRight> CashierRights()
	{
		return [
			UserRight.Can_Process_Sales,
			UserRight.Can_View_Customer_Info,
			UserRight.Can_Open_Close_Register,
		];
	}

	List<UserRight> SupervisorRights()
	{
		return [
			UserRight.Can_Process_Sales,
			UserRight.Can_View_Customer_Info,
			UserRight.Can_Open_Close_Register,
			UserRight.Can_Access_Sales_Reports,
			UserRight.Can_Manage_Inventory,
			UserRight.Can_Manage_Employees,
			UserRight.Can_Apply_Discounts,
			UserRight.Can_Override_Authorize,
			UserRight.Can_Access_Detailed_Reports,
			UserRight.Can_Handle_Refunds_Returns,
		];
	}

	List<UserRight> SalesRepresentativeRights()
	{
		return [
			UserRight.Can_Process_Sales,
			UserRight.Can_View_Customer_Info,
			UserRight.Can_Access_Sales_Reports,
			UserRight.Can_View_Own_Sales_Reports
		];
	}

	List<UserRight> InventoryManagerRights()
	{
		return[
			UserRight.Can_Manage_Inventory,
			UserRight.Can_Generate_Inventory_Reports
		];
	}
}