<?php
// gallery.php
header("Content-Type: application/json");

// Database connection details
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

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle new post
    $judul_galery = $_POST['judul_galery'];
    $isi_galery = $_POST['isi_galery'];
    
    // Handle file upload
    $target_dir = "galery/";
    $target_file = $target_dir . basename($_FILES["image"]["name"]);
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($target_file,PATHINFO_EXTENSION));

    // Check if image file is a actual image or fake image
    $check = getimagesize($_FILES["image"]["tmp_name"]);
    if($check !== false) {
        $uploadOk = 1;
    } else {
        echo json_encode(["error" => "File is not an image."]);
        $uploadOk = 0;
    }

    // Check file size
    if ($_FILES["image"]["size"] > 500000) {
        echo json_encode(["error" => "Sorry, your file is too large."]);
        $uploadOk = 0;
    }

    // Allow certain file formats
    if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
    && $imageFileType != "gif" ) {
        echo json_encode(["error" => "Sorry, only JPG, JPEG, PNG & GIF files are allowed."]);
        $uploadOk = 0;
    }

    // If everything is ok, try to upload file
    if ($uploadOk == 1) {
        if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
            $image_url = basename($_FILES["image"]["name"]);
            $tgl_post_galery = date('Y-m-d H:i:s');

            $sql = "INSERT INTO galery (judul_galery, isi_galery, images, tgl_post_galery, status_galery) VALUES (?, ?, ?, ?, 1)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("ssss", $judul_galery, $isi_galery, $image_url, $tgl_post_galery);

            if ($stmt->execute()) {
                echo json_encode(["success" => true, "message" => "Post added successfully"]);
            } else {
                echo json_encode(["error" => "Error adding post: " . $stmt->error]);
            }

            $stmt->close();
        } else {
            echo json_encode(["error" => "Sorry, there was an error uploading your file."]);
        }
    }
} else {
    // Fetch gallery data
    $sql = "SELECT kd_galery, judul_galery, isi_galery, images, tgl_post_galery FROM galery WHERE status_galery = 1 ORDER BY tgl_post_galery DESC";
    $result = $conn->query($sql);

    $gallery = array();

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $gallery[] = $row;
        }
    }

    echo json_encode($gallery);
}

$conn->close();
?>
