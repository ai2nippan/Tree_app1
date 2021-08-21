<?php
	header("Access-Control-Allow-Origin: *");
	
	
    error_reporting(0);
    error_reporting(E_ERROR | E_PARSE);
    header("content-type:text/javascript;charset=utf-8");
    // $link = mysqli_connect('localhost', 'student1', 'Abc12345', "nameDatabase"); // Origin
	// $link = mysqli_connect('localhost', 'root', '', "shoppingmallweb");
	$link = mysql_connect('localhost:3306','root','') or die(mysql_error());
	// @mysql_select_db(DB_NAME) or die(mysql_error());
	@mysql_select_db("treeflutter") or die(mysql_error());
	// @mysql_select_db(DB_NAME) or die(mysql_error());
	define('DB_FONTCODE','SET NAMES utf8');
	@mysql_query(DB_FONTCODE);
	
	
	
?>	