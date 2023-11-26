<?php
include "db.php";
    if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['user_name']) && isset($_POST['password']))
    {
        $user_name = $_POST['user_name'];
        $password = $_POST['password'];

        //Handle input validation here such as password complexity etc.

        //Check if the user is already registered:
        $existing_user_query = $conn->prepare("select * from users where user_name =?");
        $existing_user_query->bind_param("s", $user_name);
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
            $register_query = $conn->prepare("insert into users (user_name, password) values (?,?)");
            $register_query->bind_param("ss", $user_name, $hashed_password);
            if($register_query->execute())
            {
                echo "User registered successfully";
            }
            else
            {
                echo "Failed to register user";
            }
        }
    }
    else
    {
        echo "Invalid request";
    }
?>