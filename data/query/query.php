<!-- http://localhost/mikomokaru/access/collect.php?file_name=test2.php -->
<?php

    // POSTデータの取得
    $keyword = $_GET['keyword'];   
        
    /*
    print($keyword);   
    print("<br>");
    print(dirname(__FILE__));  
    print("<br>");
    print(getcwd());  
    print("<br>");
    print(posix_getpwuid(posix_geteuid())['dir']);
    print("<br>");
    print($_SERVER['DOCUMENT_ROOT']);
    print("<br>");
    print(realpath("../"));
    print("<br>");
    */
    //起点ディレクトリ
    $start = realpath("../");
    chdir($start);
    //ディレクトリ一覧
    $directory_list = array();
    
    


    
    traverse($start);

    foreach($directory_list as $dir_name){
        //print($dir_name);
        //print("<br>");
        //ファイル一覧
        $files = scandir($dir_name);
        foreach($files as $aFile){
        
            $file_path = $dir_name."/".$aFile;
            if (!is_file($file_path) || substr($aFile, 0, 1) == "." 
                || substr($aFile, 0, 1) == "_"){
                continue;
            }
            if (isTargetFile($file_path)){
                
                matching($keyword, $file_path);

                print($file_path);
                print("<br>");






            }
        }
    }
    //検索
    function matching($keyword, $file_path){
        $fp = fopen($file_path, 'r');
        while(!feof($fp)){
            $text = strip_tags(fgets($fp));
            $pattern = "/".$keyword."/";
            if(preg_match($pattern, $text, $result)){
                print("***** ".$file_path." *****<br>");
                print($result[0]."<br>");

            }

        

        }
        fclose($fp);



    }



    //ファイル種別の判定
    function isTargetFile($file_path){
        $path_info = pathinfo($file_path);
        //$kinds = array("txt", "html", "swift", "h", "m", "c", "php", "js");
        $kinds = array("php");
        if (isset($path_info['extension'])){
            foreach($kinds as $aKind){
                if (($path_info['extension']) == $aKind){
                    return TRUE;
                }
            }
        }  
        return FALSE;
    }


    //（再帰）ディレクトリトラバース
    function traverse($dir_name){
        global $directory_list;
        $dir_list = scandir($dir_name);
        if (count($dir_list) == 0 ){
            return;
        }
        foreach($dir_list as $sub_dir_name){
            $full_path = $dir_name."/".$sub_dir_name;                
            if ((substr($sub_dir_name, 0, 1) <> ".") && is_dir($full_path)){


                $directory_list[] = $full_path;
                traverse($full_path);
            }
        }
    }
?>



</body>
</html>

