<?php
$host = "localhost";
$user = "praktikum_solev";
$password = "solev2024";
$dbname = "praktikum_kelompok_solev";
   // Create connection
   $conn = new mysqli($host, $user, $password, $dbname);

   // Check connection
   if ($conn->connect_error) {
       die("Connection failed: " . $conn->connect_error);
   }

   if ($_SERVER['REQUEST_METHOD'] == 'POST') {
       $email = $_POST['email'];
       $password = $_POST['password'];

       $sql = "SELECT * FROM users WHERE email='$email' AND password='$password'";
       $result = $conn->query($sql);

       if ($result->num_rows > 0) {
           $user = $result->fetch_assoc();
           echo json_encode([
               "status" => "success", 
               "message" => "Login successful",
               "user" => [
                   "id" => $user['id'],
                   "username" => $user['username'],
                   "email" => $user['email']
               ]
           ]);
       } else {
           echo json_encode(["status" => "error", "message" => "Invalid email or password"]);
       }
   }

   $conn->close();
   ?>
