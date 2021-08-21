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
			
		$idplanter   = $_GET['idPlanter'];
		$nameplanter = $_GET['namePlanter'];
		$name        = $_GET['name'];		
		$place 	     = $_GET['place'];
		$lat 	     = $_GET['lat'];
		$lng 	     = $_GET['lng'];
		$avatar 	 = $_GET['avatar'];
		
		
							
		//$sql = "INSERT INTO `user`(`id`, `name`, `user`, `password`) VALUES (Null,'$name','$user','$password')";
		
		//$sql = "INSERT INTO `nhongshoppingmall1`.`user` (`name`, `type`, `address`, `phone`, `user`, `password`, `avatar`, `lat`, `lng`) ";
		//$sql = $sql . "VALUES ('$name', '$type', '$address', '$phone', '$user', '$password', '$avatar', '$lat', '$lng') ";
		
		//$sql = "INSERT INTO `nhongshoppingmall1`.`product` (`idSeller`, `nameSeller`, `name`, `price`, `detail`, `images`) ";
		//$sql = $sql . "VALUES ('$idSeller', '$nameSeller', '$name', '$price', '$detail', '$images');";
		
		//INSERT INTO `treeflutter`.`user` (`name`, `usertype`, `occupation`, `user`, `password`) VALUES ('Admin', 'ADMIN', 'Official', 'admin', 'password');
		
		$sql = "INSERT INTO treeflutter.plant(idPlanter,namePlanter,name,place,lat,lng,avatar) ";
		$sql = $sql . "VALUES ('$idplanter','$nameplanter','$name','$place','$lat','$lng','$avatar') ";

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