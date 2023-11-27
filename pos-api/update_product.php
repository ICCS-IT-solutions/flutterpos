<?php
include "db.php";

$product_id = $_POST['product_id']; // Assuming you have a product ID
$product_name = $_POST['product_name'];

// Check if the product ID exists in the database
$check_stmt = $conn->prepare("SELECT * FROM products WHERE product_id = ?");
$check_stmt->bind_param("i", $product_id);
$check_stmt->execute();
$result = $check_stmt->get_result();

if ($result->num_rows > 0) 
{
    // Product exists, perform an update
    $update_stmt = $conn->prepare("UPDATE products SET product_name = ? WHERE product_id = ?");
    $update_stmt->bind_param("si", $product_name, $product_id);

    if ($update_stmt->execute()) 
    {
        echo "Product updated successfully";
    } 
    else 
    {
        echo "Something went wrong while updating the product: " . $update_stmt->error;
    }

    $update_stmt->close();
} 
else 
{
    echo "Product with ID $product_id does not exist";
}

$check_stmt->close();
$conn->close();
?>
