<?php
ini_set( 'display_errors', 1 );
require_once("init.php");
require_once("MYDB.php");    
$pdo = db_connect(); 
$code = $_GET['code'];

try{
    $sql = "SELECT sales.code, name, date, unit_price, quantity, unit_price*quantity AS amount 
            FROM sales JOIN master ON sales.code =  master.code
            WHERE sales.code =:code ORDER BY sales.code ASC;";  
    $stmh = $pdo->prepare($sql);
    $stmh->bindValue(':code', $code, PDO::PARAM_INT);
    $stmh->execute();
}catch (PDOException $e) {
    die('SELECT error:'. $e->getMessage());
}

$rows = $stmh->fetchAll(PDO::FETCH_ASSOC);

//JSON形式で出力
header('Content-type: application/json');
echo json_encode($rows);

?>

