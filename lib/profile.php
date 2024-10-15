<?php
$host = "localhost";
$user = "praktikum_solev";
$password = "solev2024";
$dbname = "praktikum_kelompok_solev";

// Create connection
$conn = new mysqli($host, $user, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Use prepared statement to prevent SQL injection
$sql = "SELECT id, username, email, foto_profile FROM users WHERE id=5";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $users = array();
    while($row = $result->fetch_assoc()) {
        $users[] = $row;
    }
    echo json_encode(["success" => true, "data" => $users]);
} else {
    echo json_encode(["success" => false, "message" => "No users found"]);
}

$conn->close();
?>
