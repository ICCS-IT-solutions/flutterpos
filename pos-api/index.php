<?php

include "db.php";

$request_method = $_SERVER["REQUEST_METHOD"];
$query_string = $_SERVER["QUERY_STRING"];

//Use the query string and break it up into an array:
parse_str($query_string, $query_array);

if($request_method == "POST")
{
    //Order of params in query array: action, username, password.
    echo "Action: " . $query_array["action"];
    switch($query_array["action"])
    {  
        //Handle the login, logoff, register and reset password actions:
        case "login":

            $username = $query_array["username"];
            $password = $query_array["password"];
            include "login.php";
            break;

        case "logoff":
            include "logoff.php";
            break;

        case "register":
            $username = $query_array["username"];
            $password = $query_array["password"];
            $fullname = $query_array["name"] . " " . $query_array["surname"];
            $emailaddress = $query_array["email_address"];
            include "register.php";
            break;

        case "reset_password":
            include "resetpassword.php";
            break;

        default:
            echo "Invalid request";
            break;
    }
}

?>