<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");
	error_reporting(E_ERROR | E_PARSE);

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;	
}else {

	if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
			
		$avatar = substr($_GET['avatar'],-14);		
									
		$sql = "DELETE FROM plant WHERE avatar LIKE '%$avatar'";
		// $sql = "SELECT * FROM plant WHERE avatar LIKE '%$avatar'";
		
		//$sql = "DELETE FROM product WHERE id = '".$id."'";
		
		// $content = fopen("testChkDelete.txt","w");
		// fputs($content,$sql);
		// fclose($content);

		//$result = mysqli_query($link, $sql);
		$result = mysql_query($sql);

		if ($result) {
			echo "True";
		} else {
			echo "False";
		}

	} else echo "Welcome Master UNG";
   
}
	
}
	//mysqli_close($link);
	mysql_close($link);
?>