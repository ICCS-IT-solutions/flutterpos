<?php
session_start();
include "db.php";

//Need to get the query_array from the index.php calling this one and use the username and password from it
    $existing_user_query = $conn->prepare("SELECT * FROM users WHERE user_name = ?");
    if(!$existing_user_query)
    {
        //Kill the active session and report the error:
        die("Prepare failed: " . $conn->error);
    }
    $existing_user_query->bind_param("s", $username);
    $existing_user_query->execute();
    $existing_user_result = $existing_user_query->get_result();

    if ($existing_user_result->num_rows > 0)
    {
        //Grab the user details:
        $existing_user = $existing_user_result->fetch_assoc();

        //Execute a check against the provided password to see if its hash matches the stored one:
        //First stage: execute a check to see if the entered password matches the stored one:
        if($password == $existing_user['password'])
        {
            //Password entered is correct, now compare the hash to the stored one:
            if (password_verify($password, $existing_user['hashed_password']))
            {
                //Set the session variable:
                $_SESSION['user_name'] = $username;
                //Set the is_logged_in enum for the user to the value Y:
                $update_query = $conn->prepare("update users set is_logged_in = 'Y' where user_name = ?");
                if(!$update_query)
                {
                    //Kill the active session and report the error:
                    die("Prepare failed: " . $conn->error);
                }
                $update_query->bind_param("s", $username);
                $update_query->execute();

                //Return a response:
                $response = [
                    "status" => "success",
                    "user_name" => $username,
                    "is_logged_in" => true,
                    "message" => "Login successful",
                    "user_role" => $existing_user['user_role']
                ];
                echo json_encode($response);
                echo "Login successful";
            }
        }
        else
        {
            $response =[
                "status" => "error",
                "message" => "Invalid password"  
            ];
            echo json_encode($response);
        }
    }
    else
    {
        $response =[
            "status" => "error",
            "message" => "User not found."
        ];
        echo json_encode($response);
    }
?>