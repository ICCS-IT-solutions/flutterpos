<?php
include "db.php";

// Assuming POST request with username and password
$username = $_POST['user_name'];
$password = $_POST['password'];

// Query to fetch user details by username
$statement = $conn->prepare("SELECT * FROM users WHERE user_name = ?");
$statement->bind_param("s", $username);
$statement->execute();
$result = $statement->get_result();

if ($result->num_rows == 1) 
{
    // User found, verify password
    $user = $result->fetch_assoc();
    if (password_verify($password, $user['password'])) 
    {
        // Password matches, proceed to generate token
        $payload = array(
            'user_id' => $user['user_id'],
            'user_name' => $user['user_name'],
            // Add more user-related data to the payload as needed
        );

        // Generate token (you can use libraries like Firebase JWT or build your own)
        $secret_key = "your_secret_key"; // Replace with a secure secret key
        $token = jwt_encode($payload, $secret_key);

        // Send the token back to the client
        echo json_encode(array('token' => $token));
    } 
    else 
    {
        // Password doesn't match
        http_response_code(401); // Unauthorized
        echo "Invalid password";
    }
} 
else 
{
    // User not found
    http_response_code(404); // Not found
    echo "User not found";
}

$statement->close();
$conn->close();
?>
