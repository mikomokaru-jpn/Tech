<DOCTYPE HTML>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <title>Test</title>
  <link rel="stylesheet" href="test01.css">
</head>
<body>

<?php
ini_set( 'display_errors', 1 );
require_once("init.php");
require_once("MYDB.php");    
$pdo = db_connect(); 
$code = $_GET['code']; //パラメータの取得
try{
    $sql = "SELECT name FROM master WHERE code =:code;";  
    $stmh = $pdo->prepare($sql);
    $stmh->bindValue(':code', $code, PDO::PARAM_INT);
    $stmh->execute();
}catch (PDOException $e) {
    die('SELECT error:'. $e->getMessage());
}
$name = $stmh->fetch(PDO::FETCH_ASSOC);
print("<h2>".$name["name"]."</h2>");
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
if (empty($rows)){
    print("<h3>ありません</h3>");
}else{
    print("<div class='grid_form'>");    
    print("<div class='head'>日付</div>");
    print("<div class='head'>単価</div>");
    print("<div class='head'>数量</div>");
    print("<div class='head'>金額</div>");
    $sum_quantity = 0;
    $sum_amount = 0;
    foreach ($rows as $row) {       
        print("<div class='col'>".dateStr($row["date"])."</div>");
        print("<div class='col'>".number_format($row["unit_price"])."</div>");
        print("<div class='col'>".number_format($row["quantity"])."</div>");
        print("<div class='col'>".number_format($row["amount"])."</div>");        
        $sum_quantity += $row["quantity"];
        $sum_amount += $row["amount"];
    }
    print("<div></div>");
    print("<div class='col'>合計</div>");
    print("<div class='col'>".number_format($sum_quantity)."</div>");
    print("<div class='col'>".number_format($sum_amount)."</div>");
    print("</div>");
}

function dateStr($date){
    return substr($date, 0, 4)."/".substr($date, 4, 2)."/".substr($date, 6, 2);
}
?>


</form>
</body>
</html>
