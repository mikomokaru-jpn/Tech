<?php
ini_set( 'display_errors', 1 );
require_once("init.php");
require_once("MYDB.php");    
$pdo = db_connect(); 

try{
    $sql = "SELECT id, SUM(ref_count) AS count FROM access_codes1 GROUP BY id 
            ORDER BY id ASC;";
    $stmh = $pdo->prepare($sql);
    $stmh->execute();
}catch (PDOException $e) {
    die('SELECT error:'. $e->getMessage());
}

$rows = $stmh->fetchAll(PDO::FETCH_ASSOC);
//JSON形式で出力
header('Content-type: application/json');
echo json_encode($rows);

?>
