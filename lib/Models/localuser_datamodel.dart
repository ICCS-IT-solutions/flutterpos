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

enum LocalUserRole
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

enum LocalUserRight
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

//Should the user's hashed password and salt be kept here as variables, or does one retrieve that from the database on login?
class LocalUser
{
	final String userName;
	final String? fullName;
	final String? emailAddress;
	final String password;
	final LocalUserRole userRole;
	final String? hashedPassword;
	final String? salt;

	final List<LocalUserRight> userRights;

	LocalUser({required this.userName, required this.fullName, required this.emailAddress, required this.password, this.hashedPassword, this.salt, required this.userRole, required this.userRights});

	Map<String, dynamic> toDictionary()
	{
		final salt = AuthManager().GenerateSalt();
		final dictionary = 
		{
			"user_name": userName,
			"full_name": fullName,
			"email_address": emailAddress,
			"password": password,
			"hashed_password": AuthManager().HashPassword(password, salt),
			"salt": salt,
			"user_role": MapRoleToRoleName(userRole),
		};

		final userRights = UserRightsHandler().GetUserRights(userRole);
		const userRightValues = LocalUserRight.values;

		for (final userRight in userRightValues)
		{
			final rightString = userRight.toString().split(".").last;
			dictionary[rightString] = 
			userRights.contains(userRight) ? 'Y' : 'N';
		}
	return dictionary;
  	}

	factory LocalUser.fromDictionary(Map<String,dynamic> dictionary)
	{
		return LocalUser(
			userName: dictionary["user_name"],
			fullName: dictionary["full_name"], 
			emailAddress: dictionary["email_address"],
			password: dictionary["password"],
			hashedPassword: dictionary["hashed_password"],
			salt: dictionary["salt"], 
			userRole: MapRoleNameToRole(dictionary["user_role"]),

			//It sucks balls, but I have to do it this way :(
			//I am not sure of a working alternative because I need to assign the enum values 
			//based on the incoming string names from the dataset returned from a query. 
			userRights: [
				if(dictionary["can_process_sales"] == 'Y') LocalUserRight.Can_Process_Sales,
				if(dictionary["can_view_customer_info"] == 'Y') LocalUserRight.Can_View_Customer_Info,
				if(dictionary["can_open_close_register"] == 'Y') LocalUserRight.Can_Open_Close_Register,
				if(dictionary["can_access_sales_reports"] == 'Y') LocalUserRight.Can_Access_Sales_Reports,
				if(dictionary["can_access_order_manager"] =="Y") LocalUserRight.Can_Access_Order_Manager,
				if(dictionary["can_manage_inventory"] == 'Y') LocalUserRight.Can_Manage_Inventory,
				if(dictionary["can_manage_employees"] == 'Y') LocalUserRight.Can_Manage_Employees,
				if(dictionary["can_apply_discounts"] == 'Y') LocalUserRight.Can_Apply_Discounts,
				if(dictionary["can_access_system_settings"] == 'Y') LocalUserRight.Can_Access_System_Settings,
				if(dictionary["can_add_remove_users"] == 'Y') LocalUserRight.Can_Add_Remove_Users,
				if(dictionary["can_backup_restore_system"] == 'Y') LocalUserRight.Can_Backup_Restore_System,
				if(dictionary["can_configure_hardware"] == 'Y') LocalUserRight.Can_Configure_Hardware,
				if(dictionary["can_override_authorize"] == 'Y') LocalUserRight.Can_Override_Authorize,
				if(dictionary["can_access_detailed_reports"] == 'Y') LocalUserRight.Can_Access_Detailed_Reports,
				if(dictionary["can_handle_refunds_returns"] == 'Y') LocalUserRight.Can_Handle_Refunds_Returns,
				if(dictionary["can_manage_inventory_independently"] == 'Y') LocalUserRight.Can_Manage_Inventory_Independently,
				if(dictionary["can_generate_inventory_reports"] == 'Y') LocalUserRight.Can_Generate_Inventory_Reports,
				if(dictionary["can_view_own_sales_reports"] == 'Y') LocalUserRight.Can_View_Own_Sales_Reports,
				if(dictionary["read_permission"] == 'Y') LocalUserRight.Read_Permission,
				if(dictionary["write_permission"] == 'Y') LocalUserRight.Write_Permission,
			]
		);
	}
}

LocalUserRole MapRoleNameToRole(String roleString)
{
	switch(roleString)
	{
		case "Cashier":
			return LocalUserRole.Cashier;
		case "Manager":
			return LocalUserRole.Manager;
		case "Administrator":
			return LocalUserRole.Administrator;
		case "Supervisor":
			return LocalUserRole.Supervisor;
		case "Inventory_Manager":
			return LocalUserRole.Inventory_Manager;
		case "Sales_Representative":
			return LocalUserRole.Sales_Representative;
		default:
			return LocalUserRole.User;
	}
}

String MapRoleToRoleName(LocalUserRole role)
{
	switch(role)
	{
		case LocalUserRole.Cashier:
			return "Cashier";
		case LocalUserRole.Manager:
			return "Manager";
		case LocalUserRole.Administrator:
			return "Administrator";
		case LocalUserRole.Supervisor:
			return "Supervisor";
		case LocalUserRole.Inventory_Manager:
			return "Inventory_Manager";
		case LocalUserRole.Sales_Representative:
			return "Sales_Representative";
		default:
			return "User";
	}
}

//Rights handler class
class UserRightsHandler
{
	List<LocalUserRight> GetUserRights(LocalUserRole role)
	{
		switch(role)
		{
		case LocalUserRole.Cashier:
			return CashierRights();
		case LocalUserRole.Manager:
			return ManagerRights();
		case LocalUserRole.Administrator:
			return AdministratorRights();
		case LocalUserRole.Supervisor:
			return SupervisorRights();
		case LocalUserRole.Inventory_Manager:
			return InventoryManagerRights();
		case LocalUserRole.Sales_Representative:
			return SalesRepresentativeRights();
		case LocalUserRole.User:
		//Users dont yet have any rights to the system.
			return [];
		}
	}

	List<LocalUserRight> AdministratorRights()
	{
		//All these rights apply to administrators, in IT circles they are often referred to as the superuser:
		return [
			LocalUserRight.Can_Process_Sales,
			LocalUserRight.Can_View_Customer_Info,
			LocalUserRight.Can_Open_Close_Register,
			LocalUserRight.Can_Access_Sales_Reports,
			LocalUserRight.Can_Access_Order_Manager,
			LocalUserRight.Can_Manage_Inventory,
			LocalUserRight.Can_Manage_Employees,
			LocalUserRight.Can_Apply_Discounts,
			LocalUserRight.Can_Access_System_Settings,
			LocalUserRight.Can_Add_Remove_Users,
			LocalUserRight.Can_Backup_Restore_System,
			LocalUserRight.Can_Configure_Hardware,
			LocalUserRight.Can_Override_Authorize,
			LocalUserRight.Can_Access_Detailed_Reports,
			LocalUserRight.Can_Handle_Refunds_Returns,
			LocalUserRight.Can_Manage_Inventory_Independently,
			LocalUserRight.Can_Generate_Inventory_Reports,
			LocalUserRight.Can_View_Own_Sales_Reports,
			LocalUserRight.Read_Permission,
			LocalUserRight.Write_Permission,
		];
	}

	List<LocalUserRight> ManagerRights()
	{
		return[
			LocalUserRight.Can_Process_Sales,
			LocalUserRight.Can_View_Customer_Info,
			LocalUserRight.Can_Open_Close_Register,
			LocalUserRight.Can_Access_Sales_Reports,
			LocalUserRight.Can_Manage_Inventory,
			LocalUserRight.Can_Manage_Employees,
			LocalUserRight.Can_Apply_Discounts,
		];
	}

	List<LocalUserRight> CashierRights()
	{
		return [
			LocalUserRight.Can_Process_Sales,
			LocalUserRight.Can_View_Customer_Info,
			LocalUserRight.Can_Open_Close_Register,
		];
	}

	List<LocalUserRight> SupervisorRights()
	{
		return [
			LocalUserRight.Can_Process_Sales,
			LocalUserRight.Can_View_Customer_Info,
			LocalUserRight.Can_Open_Close_Register,
			LocalUserRight.Can_Access_Sales_Reports,
			LocalUserRight.Can_Manage_Inventory,
			LocalUserRight.Can_Manage_Employees,
			LocalUserRight.Can_Apply_Discounts,
			LocalUserRight.Can_Override_Authorize,
			LocalUserRight.Can_Access_Detailed_Reports,
			LocalUserRight.Can_Handle_Refunds_Returns,
		];
	}

	List<LocalUserRight> SalesRepresentativeRights()
	{
		return [
			LocalUserRight.Can_Process_Sales,
			LocalUserRight.Can_View_Customer_Info,
			LocalUserRight.Can_Access_Sales_Reports,
			LocalUserRight.Can_View_Own_Sales_Reports
		];
	}

	List<LocalUserRight> InventoryManagerRights()
	{
		return[
			LocalUserRight.Can_Manage_Inventory,
			LocalUserRight.Can_Generate_Inventory_Reports
		];
	}

	//Need a copyWith method for the purpose of updating an existing user selectively.
	//Also need a way to make sure that the permissions are adjusted to the role of the user.
}