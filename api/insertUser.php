<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

// if (!$link->set_charset("utf8")) {
    // printf("Error loading character set utf8: %s\n", $link->error);
    // exit();
	// }

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
			
		$name    	= $_GET['name'];
		$occupation = $_GET['occupation'];
		$sex        = $_GET['sex'];		
		$age 	    = $_GET['age'];
		$email 	    = $_GET['email'];
		$phone 	    = $_GET['phone'];
		$user 	    = $_GET['user'];
		$password   = $_GET['password'];
		
							
		//$sql = "INSERT INTO `user`(`id`, `name`, `user`, `password`) VALUES (Null,'$name','$user','$password')";
		
		//$sql = "INSERT INTO `nhongshoppingmall1`.`user` (`name`, `type`, `address`, `phone`, `user`, `password`, `avatar`, `lat`, `lng`) ";
		//$sql = $sql . "VALUES ('$name', '$type', '$address', '$phone', '$user', '$password', '$avatar', '$lat', '$lng') ";
		
		//$sql = "INSERT INTO `nhongshoppingmall1`.`product` (`idSeller`, `nameSeller`, `name`, `price`, `detail`, `images`) ";
		//$sql = $sql . "VALUES ('$idSeller', '$nameSeller', '$name', '$price', '$detail', '$images');";
		
		//INSERT INTO `treeflutter`.`user` (`name`, `usertype`, `occupation`, `user`, `password`) VALUES ('Admin', 'ADMIN', 'Official', 'admin', 'password');
		
		$sql = "INSERT INTO treeflutter.user(name,usertype,occupation,sex,age,email,phone,user,password) ";
		$sql = $sql . "VALUES ('$name','USER','$occupation','$sex','$age','$email','$phone','$user','$password') ";

		// $result = mysqli_query($link, $sql);
		$result = mysql_query($sql) or die("error : $sql");

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}
	// mysqli_close($link);
?>