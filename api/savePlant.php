<?php
error_reporting(E_ERROR | E_PARSE);

// Response object structure
$response = new stdClass;
$response->status = null;
$response->message = null;

// Uploading file
$destination_dir = "plant/";
$base_filename = basename($_FILES["file"]["name"]);
$target_file = $destination_dir . $base_filename;

if(!$_FILES["file"]["error"])
{
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {        
        $response->status = true;
        $response->message = "File uploaded successfully";

    } else {

        $response->status = false;
        $response->message = "File uploading failed";
    }    
} 
else
{
    $response->status = false;
    $response->message = "File uploading failed";
}

header('Content-Type: application/json');
echo json_encode($response);

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