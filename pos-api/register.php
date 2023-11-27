<?php
include "db.php";
           //Handle input validation here such as password complexity etc.

        //Check if the user is already registered:
        $existing_user_query = $conn->prepare("select * from users where user_name =?");
        if(!$existing_user_query)
        {
            //Kill the active session and report the error:
            die("Prepare failed: " . $conn->error);
        }
        $existing_user_query->bind_param("s", $username);
        $existing_user_query->execute();
        $existing_user_result = $existing_user_query->get_result();

        //If this user already is registered, return an error to the client:
        if ($existing_user_result->num_rows > 0)
        {
            echo "User already exists";
        }
        else
        {
            //Hash the password
            $hashed_password = password_hash($password, PASSWORD_DEFAULT);
            //Register the user:
            $register_query = $conn->prepare("insert into users (user_name, full_name, email_address, password, hashed_password) values (?,?,?,?,?)");
            $register_query->bind_param("sssss", $username, $fullname, $emailaddress, $password, $hashed_password);
            if($register_query->execute())
            {
                echo "User registered successfully";
                if(!empty($query_array['user_role']))
                {
                    $role = $query_array['user_role'];
                }
                else
                {
                    $role = "user";
                }
                $update_query = $conn->prepare("update users set user_role = '?' where user_name = ?");
                if(!$update_query)
                {
                    //Kill the active session and report the error:
                    die("Prepare failed: " . $conn->error);
                }
                $update_query->bind_param("ss", $username ,$role);
                $update_query->execute();
                //Third stage: Handle the user role rights:
                switch($role)
                {   
                    //Will need to handle disabling rights for other users where the Y value is not set, it should be treated as N by default.
                    case "Administrator":
                        //Need to store these in the database with their values set to 'Y':
                        $Can_Process_Sales = 'Y';
                        $Can_View_Customer_Info = 'Y';
                        $Can_Open_Close_Register = 'Y';
                        $Can_Access_Sales_Reports = 'Y';
                        $Can_Access_Order_Manager = 'Y';
                        $Can_Manage_Inventory = 'Y';
                        $Can_Manage_Employees = 'Y';
                        $Can_Apply_Discounts = 'Y';
                        $Can_Access_System_Settings = 'Y';
                        $Can_Add_Remove_Users = 'Y';
                        $Can_Backup_Restore_System = 'Y';
                        $Can_Configure_Hardware = 'Y';
                        $Can_Override_Authorize = 'Y';
                        $Can_Access_Detailed_Reports = 'Y';
                        $Can_Handle_Refunds_Returns = 'Y';
                        $Can_Manage_Inventory_Independently = 'Y';
                        $Can_Generate_Inventory_Reports = 'Y';
                        $Can_View_Own_Sales_Reports = 'Y';
                        $Read_Permission = 'Y';
                        $Write_Permission = 'Y';
                        break;
                    case "Manager":
                        $Can_Process_Sales = 'Y';
                        $Can_View_Customer_Info = 'Y';
                        $Can_Open_Close_Register = 'Y';
                        $Can_Access_Sales_Reports = 'Y';
                        $Can_Access_Order_Manager = 'Y';
                        $Can_Manage_Inventory = 'Y';
                        $Can_Manage_Employees = 'Y';
                        $Can_Apply_Discounts = 'Y';                        
                        break;
                    case "Supervisor":
                        $Can_Process_Sales = 'Y';
                        $Can_View_Customer_Info = 'Y';
                        $Can_Open_Close_Register = 'Y';
                        $Can_Access_Sales_Reports = 'Y';
                        $Can_Access_Order_Manager = 'Y';
                        $Can_Manage_Inventory = 'Y';
                        $Can_Manage_Employees = 'Y';
                        $Can_Apply_Discounts = 'Y';    
                        $Can_Override_Authorize = 'Y';
                        $Can_Access_Detailed_Reports = 'Y';
                        $Can_Handle_Refunds_Returns = 'Y';                                            
                        break;
                    case "Cashier":
                        $Can_Process_Sales = 'Y';
                        $Can_View_Customer_Info = 'Y';
                        $Can_Open_Close_Register = 'Y';
                        break;
                    case "Inventory_Manager":
                        $Can_Manage_Inventory = 'Y';
                        $Can_Generate_Inventory_Reports = 'Y';
                    case "Sales_Representative":
                        $Can_Process_Sales = 'Y';
                        $Can_View_Customer_Info = 'Y';
                        $Can_Access_Sales_Reports = 'Y';
                        $Can_View_Own_Sales_Reports = 'Y';
                    case "User":
                        //Catch-all case for unassigned users at this point.
                        break;
                    default:
                    echo "Invalid user role specified.";
                        break;
                    $update_rights_query = $conn->prepare("update users set Can_Process_Sales = ?,
                    Can_View_Customer_Info = ?,
                    Can_Open_Close_Register = ?,
                    Can_Access_Sales_Reports = ?,
                    Can_Access_Order_Manager = ?,
                    Can_Manage_Inventory = ?,
                    Can_Manage_Employees = ?,
                    Can_Apply_Discounts = ?,
                    Can_Access_System_Settings = ?,
                    Can_Add_Remove_Users = ?,
                    Can_Backup_Restore_System = ?,
                    Can_Configure_Hardware = ?,
                    Can_Override_Authorize = ?,
                    Can_Access_Detailed_Reports = ?,
                    Can_Handle_Refunds_Returns = ?,
                    Can_Manage_Inventory_Independently = ?,
                    Can_Generate_Inventory_Reports = ?,
                    Can_View_Own_Sales_Reports = ?,
                    Read_Permission = ?,
                    Write_Permission = ? where user_name = ?");
                }
                //After identifying the role, these rights have to be assigned to the user:

            }
            else
            {
                echo "Failed to register user";
            }
        }
?>