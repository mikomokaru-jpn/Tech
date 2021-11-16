"use strict";  
window.load = countUp(); //ウィンドウロード時にカウントアップする
//ページ参照カウントの収集
function countUp(){
    let request = new XMLHttpRequest()
    request.open('POST', '/lib/access/collect.php');
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    let param = `file_name=${location.pathname}`;
    console.log("countUp " + param);
    request.send(param);    
}