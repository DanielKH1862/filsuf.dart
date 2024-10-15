<?php
// Database connection details
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "praktikum";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// SQL query to fetch the username from the "Selamat Datang!" message
$sql = "SELECT username FROM users WHERE id = 5"; // Adjust this query as needed

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $username = $row["username"];
} else {
    $username = "Tamu";
}

// Return the username as JSON
echo json_encode(["username" => $username]);

$conn->close();
?>