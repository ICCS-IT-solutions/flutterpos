<?php
include "db.php";

$product_name = $_POST['product_name'];

$statement =  $conn->prepare("INSERT INTO products (product_name) VALUES (?)");
$statement->bind_param("s", $product_name);

if ($statement->execute)
{
    echo "Product registered successfully";
}
else
{
    "Something went wrong while registering a product!\n" . $statement->error;
}

$statement->close();
$conn->close();

?>