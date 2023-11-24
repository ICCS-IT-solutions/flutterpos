
<?php

//Set up our DB connection:

$host = "localhost";
$user = "dbadmin";
$pass = "C3r3$123!";
$db = "flutterposdb";

$conn = new mysqli($host,$user,$pass,$db);

if($conn->connect_error)
{
    die("Connection failed: " . $conn->connect_error);
}

?>
