<?php
    ini_set( 'display_errors', 1 );
    require_once("init.php");
    require_once("MYDB.php");    
    $pdo = db_connect(); 
    //データの取得
    date_default_timezone_set('Asia/Tokyo');
    $date = (int)date("Ymd");
    $id = $_POST['id'];   
    $ip_address = $_SERVER["REMOTE_ADDR"];   

/* レコードを求める
  date         日付 YYYYMMDD 
  id           レコードID      
  ip_address   IPアドレス 
*/
try{
    $sql = "SELECT * FROM access_codes1 
            WHERE date=:date AND id=:id AND ip_address=:ip_address;";
    $stmh = $pdo->prepare($sql);
    $stmh->bindValue(':date', $date, PDO::PARAM_INT);
    $stmh->bindValue(':id', $id, PDO::PARAM_INT);
    $stmh->bindValue(':ip_address', $ip_address, PDO::PARAM_INT);
    $stmh->execute();
}catch (PDOException $e) {
    error_log("collect_codes1.php ". $e->getMessage());    
    die('SELECT error');
}
//結果を取得
$rows = $stmh->fetchAll(PDO::FETCH_ASSOC);
if (empty($rows)){
    //なければINSERT
    try{
        $sql = "INSERT INTO access_codes1 
                VALUES (:date, :id, :ip_address, :ref_count);";
        $stmh = $pdo->prepare($sql);
        $stmh->bindValue(':date', $date, PDO::PARAM_INT);
        $stmh->bindValue(':id', $id, PDO::PARAM_INT);
        $stmh->bindValue(':ip_address', $ip_address, PDO::PARAM_STR);
        $stmh->bindValue(':ref_count', 1, PDO::PARAM_INT);
        $stmh->execute();
    }catch (PDOException $e) {
        error_log("collect_codes1.php ". $e->getMessage());    
        die('INSERT error');
    }
}else{  
    //あればUPDATE    
    $cnt = $rows[0]["ref_count"];
    try{
        $sql = "UPDATE access_codes1
                SET ref_count=:ref_count  
                WHERE date=:date AND id=:id AND ip_address=:ip_address;";
        $stmh = $pdo->prepare($sql);
        $stmh->bindValue(':date', $date, PDO::PARAM_INT);
        $stmh->bindValue(':id', $id, PDO::PARAM_INT);
        $stmh->bindValue(':ip_address', $ip_address, PDO::PARAM_STR);        
        $stmh->bindValue(':ref_count', $cnt+1, PDO::PARAM_INT);
        $stmh->execute();
        
    }catch (PDOException $e) {
        error_log("collect_codes1.php ". $e->getMessage());    
        die('UPDATE error:');
    }
}        
?>


