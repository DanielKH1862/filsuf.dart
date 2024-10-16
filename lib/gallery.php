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

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    // Handle delete request
    $kd_galery = $_GET['kd_galery'];
    
    // First, get the image filename
    $sql = "SELECT images FROM galery WHERE kd_galery = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $kd_galery);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $image_filename = $row['images'];
        
        // Delete the record from the database
        $sql = "DELETE FROM galery WHERE kd_galery = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $kd_galery);
        
        if ($stmt->execute()) {
            // If database deletion is successful, delete the image file
            $image_path = "galery/" . $image_filename;
            if (file_exists($image_path)) {
                unlink($image_path);
            }
            echo json_encode(["success" => true, "message" => "Gallery item deleted successfully"]);
        } else {
            echo json_encode(["error" => "Error deleting gallery item: " . $stmt->error]);
        }
        
        $stmt->close();
    } else {
        echo json_encode(["error" => "Gallery item not found"]);
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action']) && $_POST['action'] === 'edit') {
        // Handle edit request
        $kd_galery = $_POST['kd_galery'];
        $judul_galery = $_POST['judul_galery'];
        $isi_galery = $_POST['isi_galery'];
        
        $sql = "UPDATE galery SET judul_galery = ?, isi_galery = ? WHERE kd_galery = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sss", $judul_galery, $isi_galery, $kd_galery);
        
        if ($stmt->execute()) {
            // Check if a new image was uploaded
            if (isset($_FILES["image"]) && $_FILES["image"]["error"] == 0) {
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
                        
                        // Update the image in the database
                        $sql = "UPDATE galery SET images = ? WHERE kd_galery = ?";
                        $stmt = $conn->prepare($sql);
                        $stmt->bind_param("ss", $image_url, $kd_galery);
                        $stmt->execute();
                        
                        // Delete the old image file
                        $old_image = $_POST['old_image'];
                        if (file_exists($target_dir . $old_image)) {
                            unlink($target_dir . $old_image);
                        }
                    } else {
                        echo json_encode(["error" => "Sorry, there was an error uploading your file."]);
                        exit;
                    }
                }
            }
            
            echo json_encode(["success" => true, "message" => "Gallery item updated successfully"]);
        } else {
            echo json_encode(["error" => "Error updating gallery item: " . $stmt->error]);
        }
        
        $stmt->close();
    } else {
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
