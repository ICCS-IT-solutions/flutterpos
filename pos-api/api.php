<?php
include "db.php";

//Authentication-related endpoints
    //endpoint : register -> new user is registering on the system.
    if (isset($_POST['register'])) 
    {
        include "api/register.php";   
    }
    //Login endpoint
    elseif (isset($_POST['login']))
    {
        include "api/login.php";
    }
    //Logoff endpoint
    elseif (isset($_POST['logoff']))
    {
        include "api/logoff.php";
    }
    //Reset password endpoint
    elseif (isset($_POST['resetpassword']))
    {
        include "api/resetpassword.php";
    }

//Create, read, update and delete endpoints
    //Create endpoint
    elseif (isset($_POST['create']))
    {

    }
    //Read endpoint
    elseif (isset($_POST['read']))
    {

    }
    //Update endpoint
    elseif (isset($_POST['update']))
    {

    }

    //Delete endpoint
    elseif (isset($_POST['delete']))
    {

    }

    //Else return an error to the caller
    else
    {
        echo "Invalid request";
    }
?>