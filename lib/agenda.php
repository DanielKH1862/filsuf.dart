<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "praktikum";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        getAgenda($conn);
        break;
    case 'POST':
        addAgenda($conn);
        break;
    case 'PUT':
        updateAgenda($conn);
        break;
    case 'DELETE':
        deleteAgenda($conn);
        break;
    default:
        echo json_encode(["error" => "Invalid request method"]);
        break;
}

function getAgenda($conn) {
    $sql = "SELECT * FROM agenda ORDER BY tgl_agenda DESC";
    $result = $conn->query($sql);

    $data = array();
    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
    }
    echo json_encode($data);
}

function addAgenda($conn) {
    $data = json_decode(file_get_contents("php://input"), true);
    $judul_agenda = $conn->real_escape_string($data['judul_agenda']);
    $isi_agenda = $conn->real_escape_string($data['isi_agenda']);
    $tgl_agenda = $conn->real_escape_string($data['tgl_agenda']);
    $tgl_post_agenda = date('Y-m-d H:i:s');

    $sql = "INSERT INTO agenda (judul_agenda, isi_agenda, tgl_agenda, tgl_post_agenda) VALUES ('$judul_agenda', '$isi_agenda', '$tgl_agenda', '$tgl_post_agenda')";
    
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["message" => "Agenda added successfully"]);
    } else {
        echo json_encode(["error" => "Error: " . $conn->error]);
    }
}

function updateAgenda($conn) {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = intval($conn->real_escape_string($data['kd_agenda']));
    $judul_agenda = $conn->real_escape_string($data['judul_agenda']);
    $isi_agenda = $conn->real_escape_string($data['isi_agenda']);
    $tgl_agenda = $conn->real_escape_string($data['tgl_agenda']);

    $sql = "UPDATE agenda SET judul_agenda='$judul_agenda', isi_agenda='$isi_agenda', tgl_agenda='$tgl_agenda' WHERE kd_agenda=$id";
    
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["message" => "Agenda updated successfully"]);
    } else {
        echo json_encode(["error" => "Error: " . $conn->error]);
    }
}

function deleteAgenda($conn) {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = intval($conn->real_escape_string($data['kd_agenda']));

    $sql = "DELETE FROM agenda WHERE kd_agenda=$id";
    
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["message" => "Agenda deleted successfully"]);
    } else {
        echo json_encode(["error" => "Error: " . $conn->error]);
    }
}

$conn->close();
?>
