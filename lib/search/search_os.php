<?php
ini_set( 'display_errors', 1 );
require_once("search_main.php");

$keywords = $_GET['keyword'];  //検索語の配列
$caseFlag = $_GET['case'];     //検索語の配列
               
$root = $_SERVER['DOCUMENT_ROOT'];
$result = array();
//OS関連フォルダの検索
foreach(glob($root."/data/*") as $dir) {
    if (is_dir($dir)){
        //フォルダ         
        $folder = pathinfo($dir)["filename"];
        //htmlファイルのタグからタイトルを取得
        $title = getTitle($dir ."/*");
        //フォルダ直下の検索
        searchFiles($dir ."/*", $title, true);
        //フォルダ/source 直下の検索
        searchFiles($dir ."/source/*", $title, false);      
    }
}
//サンプルコーディング集1
foreach(glob($root."/sample1/*") as $dir) {
    if (is_dir($dir)){
        //フォルダ     
        $folder = pathinfo($dir)["filename"];
        //フォルダ直下の検索
        $title = getTitle($dir ."/*");
        searchFiles($dir ."/*", $title, false);
    }
}
//JSON形式で出力
header('Content-type: application/json');
echo json_encode($result);
//echo json_encode($keywords);
?>



