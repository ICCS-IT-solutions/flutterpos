<?php
session_start();
include "db.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['user_name']))
{
    //Unset all values in the session:
    $_SESSION = array();

    //Erase the session entirely:
    session_destroy();

    echo "Logged off";
}
else
{
    echo "Invalid request";
}
?>