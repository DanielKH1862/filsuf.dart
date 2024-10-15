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

// Get the user ID from the GET parameter
$id = isset($_GET['id']) ? $_GET['id'] : null;

if ($id === null) {
    echo json_encode(["success" => false, "message" => "No user ID provided"]);
    exit;
}

// Use prepared statement to prevent SQL injection
$stmt = $conn->prepare("SELECT * FROM users WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $users = array();
    while($row = $result->fetch_assoc()) {
        $users[] = $row;
    }
    echo json_encode(["success" => true, "data" => $users]);
} else {
    echo json_encode(["success" => false, "message" => "No user found"]);
}

$stmt->close();
$conn->close();
?>
