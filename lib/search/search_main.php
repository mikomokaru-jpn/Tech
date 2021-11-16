<?php
ini_set( 'display_errors', 1 );

//タイトル取得
function getTitle($dir){
    $title = ""; 
    foreach(glob($dir) as $fileName) {
        if (is_file($fileName)) {
            $info =  pathinfo($fileName); //ファイル情報   
            if (array_key_exists("extension", $info) &&  $info["extension"] == "html"){
                //html記事・フォルダに1ファイルという前提
                $articleURL = $fileName; //完全パス名 
                $articleFile = $info["basename"];  
                //ファイル読み込み
                $content = file_get_contents($fileName);
                //タイトルの取得                    
                $pattern = "/<title>(.*)<\/title>/";
                if (preg_match_all($pattern, $content, $matchList)){
                    $title = $matchList[1][0]; 
                }
            }
        }
    }  
    return $title;
}
//文字列検索
function searchFiles($dir, $title, $includeHTML){

    global $keywords, $root, $result, $caseFlag;  //グローバル変数

    foreach(glob($dir) as $fileName) {
        if (is_file($fileName)) {
            $info =  pathinfo($fileName); //ファイル情報       
            if (array_key_exists("extension", $info) && ( 
                  $info["extension"] == "txt" || $info["extension"] == "h" ||
                  $info["extension"] == "m" || $info["extension"] == "c" ||  
                  $info["extension"] == "swift" || $info["extension"] == "html" ||  
                  $info["extension"] == "php" || $info["extension"] == "js")){

                if (!$includeHTML && $info["extension"] == "html"){
                    continue;
                }
                //ファイル読み込み
                $content = file_get_contents($fileName);
                //キーワード検索 
                $url = str_replace($root, "",  $fileName);
                $record = array("url" => $url,                   //ファイルのURL
                                "file" => $info["basename"],     //ファイル名
                                "count" => 0,                    //マッチ件数
                                "folder" => str_replace($info["basename"], "", $url), //フォルダ名     
                                "title" => $title,               //タイトル
                                "html" => false);       
                if ($info["extension"] == "html"){
                    $record["html"] = true;
                }         
                $match_count = 0;
                $no_match = false;  
                $iFlag = "";
                if ($caseFlag == "NO"){
                    $iFlag = "i";
                }
                foreach($keywords as $word){                    
                    $pattern = "/".$word."/".$iFlag; //フラグgは使えない
                    if(preg_match_all($pattern, $content, $matchList)){
                        $match_count = count($matchList[0]);
                    }else{
                        $no_match = true;
                        break;
                    }
                }
                if (!$no_match){
                    $record["count"] =  $match_count;
                    array_push($result, $record);
                }  
            }
        }
    }
}
?>
