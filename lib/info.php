<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$host = 'localhost';
$db   = 'praktikum_kelompok_solev';
$user = 'praktikum_solev';
$pass = 'solev2024';

// Create connection
$conn = new mysqli($host, $user, $pass, $db);


// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        getInfo($conn);
        break;
    case 'POST':
        createInfo($conn);
        break;
    case 'PUT':
        updateInfo($conn);
        break;
    case 'DELETE':
        deleteInfo($conn);
        break;
    default:
        echo json_encode(["status" => "error", "message" => "Invalid request method"]);
        break;
}

function getInfo($conn) {
    $sql = "SELECT * FROM informasi";
    $result = $conn->query($sql);

    $data = array();
    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode(["status" => "success", "data" => $data]);
    } else {
        echo json_encode(["status" => "success", "data" => []]);
    }
}

function createInfo($conn) {
    $input = json_decode(file_get_contents('php://input'), true);
    $judul_info = $input['judul_info'] ?? null;
    $isi_info = $input['isi_info'] ?? null;

    if (!$judul_info || !$isi_info) {
        echo json_encode(["status" => "error", "message" => "Missing required fields"]);
        return;
    }

    $sql = "INSERT INTO informasi (judul_info, isi_info, tgl_post_info) VALUES (?, ?, CURRENT_TIMESTAMP)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $judul_info, $isi_info);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Information created successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error creating information: " . $conn->error]);
    }
    $stmt->close();
}

function updateInfo($conn) {
    $input = json_decode(file_get_contents('php://input'), true);
    $id = $input['id'] ?? '';
    $judul_info = $input['judul_info'] ?? null;
    $isi_info = $input['isi_info'] ?? null;

    if (empty($id) || !$judul_info || !$isi_info) {
        echo json_encode(["status" => "error", "message" => "Missing or invalid required fields"]);
        return;
    }

    $sql = "UPDATE informasi SET judul_info = ?, isi_info = ?, tgl_post_info = CURRENT_TIMESTAMP WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sss", $judul_info, $isi_info, $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Information updated successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error updating information: " . $conn->error]);
    }
    $stmt->close();
}

function deleteInfo($conn) {
    $input = json_decode(file_get_contents('php://input'), true);
    $id = $input['id'] ?? '';

    if (empty($id)) {
        echo json_encode(["status" => "error", "message" => "Missing or invalid ID"]);
        return;
    }

    $sql = "DELETE FROM informasi WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Information deleted successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error deleting information: " . $conn->error]);
    }
    $stmt->close();
}

$conn->close();
?>
