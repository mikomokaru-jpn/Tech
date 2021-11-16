<!-- http://localhost/lib/access/collect.php?file_name=test2.php -->
<?php
    ini_set( 'display_errors', 1 );
    require_once("init.php");
    require_once("MYDB.php");    
    $pdo = db_connect(); 
    // POSTデータの取得
    $ip_address = $_SERVER["REMOTE_ADDR"];          
    $file_name = $_POST['file_name'];   
    date_default_timezone_set('Asia/Tokyo');
    $date = (int)date("Ymd");
    $time = (int)date("His");
    $sql = "INSERT INTO access VALUES (:date, :time, :ip_address, :file_name);";
        $stmh = $pdo->prepare($sql);
        $stmh->bindValue(':date', $date, PDO::PARAM_INT);
        $stmh->bindValue(':time', $time, PDO::PARAM_INT);
        $stmh->bindValue(':ip_address', $ip_address, PDO::PARAM_STR);
        $stmh->bindValue(':file_name', $file_name, PDO::PARAM_STR);
        $stmh->execute();
?>
</body>
</html>

