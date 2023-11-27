<?php
include "db.php";

$product_id = $_POST['product_id']; // Assuming you have a product ID

// Check if the product ID exists in the database
$check_stmt = $conn->prepare("SELECT * FROM products WHERE product_id = ?");
$check_stmt->bind_param("i", $product_id);
$check_stmt->execute();
$result = $check_stmt->get_result();

if ($result->num_rows > 0) 
{
    // Product exists, perform the delete operation
    $delete_stmt = $conn->prepare("DELETE FROM products WHERE product_id = ?");
    $delete_stmt->bind_param("i", $product_id);

    if ($delete_stmt->execute()) 
    {
        echo "Product deleted successfully";
    } 
    else 
    {
        echo "Something went wrong while deleting the product: " . $delete_stmt->error;
    }

    $delete_stmt->close();
} 
else 
{
    echo "Product with ID $product_id does not exist";
}

$check_stmt->close();
$conn->close();
?>