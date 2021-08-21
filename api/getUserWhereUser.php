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
				
		$user = $_GET['user'];

		// $result = mysqli_query($link, "SELECT * FROM user WHERE user = '$user'");
		$sql = "SELECT * FROM user WHERE user = '$user'";
		
		$result = mysql_query($sql) or die("error : $sql");

		if ($result) {

			// while($row=mysqli_fetch_assoc($result)){
			while($row=mysql_fetch_assoc($result)){	
			$output[]=$row;

			}	// while

			echo json_encode($output);

		} //if

	} else echo "Welcome to Tree Application";	// if2
   
}	// if1


	// mysqli_close($link);
	
	function json_encode($a=false)
	{
		if (is_null($a)) return 'null';
		if ($a === false) return 'false';
		if ($a === true) return 'true';
		if (is_scalar($a))
		{
			if (is_float($a))
			{
				// Always use "." for floats.
				return floatval(str_replace(",", ".", strval($a)));
			}

			if (is_string($a))
			{
				static $jsonReplaces = array(array("\\", "/", "\n", "\t", "\r", "\b", "\f", '"'), array('\\\\', '\\/', '\\n', '\\t', '\\r', '\\b', '\\f', '\"'));
				return '"' . str_replace($jsonReplaces[0], $jsonReplaces[1], $a) . '"';
			}
			else
			return $a;
		}
		$isList = true;
		for ($i = 0, reset($a); $i < count($a); $i++, next($a))
		{
			if (key($a) !== $i)
			{
				$isList = false;
				break;
			}
		}
		$result = array();
		if ($isList)
		{
			foreach ($a as $v) $result[] = json_encode($v);
			return '[' . join(',', $result) . ']';
		}
		else
		{
			foreach ($a as $k => $v) $result[] = json_encode($k).':'.json_encode($v);
			return '{' . join(',', $result) . '}';
		}
	}
?>