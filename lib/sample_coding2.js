"use strict";
let jsList = [
[0, "文字列の操作", "", "/sample2/16/sample.txt"],
[0, "正規表現", "", "/sample2/17/sample.txt"],
[0, "for文", "", "/sample2/10/sample.txt"],
[0, "ラジオボタンを作成する", "", "/sample2/20/sample.txt"],
[0, "セレクトボックスを作成する", "", "/sample2/21/sample.txt"],
[0, "HTTPリクエストの送受信 / GET", "", "/sample2/11/sample.txt"],
[0, "HTTPリクエストの送受信 / POST", "", "/sample2/12/sample.txt"],
[0, "HTTPリクエストの送受信 / POST JSONデータ送る", "", "/sample2/13/sample.txt"],
[0, "HTML/JavaScriptに配列を引数にしてGETリクエストを送る", "", "/sample2/19/sample.txt"],
[0, "数値をカンマ区切りにして表示する", "", "/sample2/14/sample.txt"],
[0, "連想配列を要素に持った配列をソートする", "", "/sample2/15/sample.txt"]
];

let phpList = [
[0, "POSTパラメータを取得する", "", "/sample2/1/sample.txt"],
[0, "POSTパラメータとしてJSON文字列を取得する", "", "/sample2/2/sample.txt"],
[0, "GETパラメータを取得する", "", "/sample2/3/sample.txt"],
[0, "PHPに配列を引数にしてGETリクエストを送る", "", "/sample2/18/sample.txt"],
[0, "データベースに接続する", "", "/sample2/4/sample.txt"],
[0, "SQL テーブルの照会", "", "/sample2/5/sample.txt"],
[0, "SQL テーブルの照会 / JSONデータとして返す", "", "/sample2/6/sample.txt"],
[0, "SQL テーブルの更新", "", "/sample2/7/sample.txt"],
[0, "ディレクトリ関連", "", "/sample2/8/sample.txt"],
[0, "ディレクトリの下のファイル一覧を求める再帰処理", "", "/sample2/9/sample.txt"]
];


const listTop = document.querySelector('#ListTop');                     //要素の先頭位置

//開始
window.onload = function(){ 
    //初期処理
    setUp();
}

//ソート＆表示
function setUp(){
    displayList();
}
//一覧表示
function displayList(){
    //既存のタグの削除
    while(listTop.firstChild){
        listTop.removeChild(listTop.firstChild);
    }
    
    const head2 = document.createElement('h3'); 
    head2.setAttribute('class', 'lm20 tm10 bm0');
    head2.innerHTML = "Java Script";
    listTop.appendChild(head2);
    setTag(jsList);
    
    const head1 = document.createElement('h3'); 
    head1.setAttribute('class', 'lm20 tm5 bm0');
    head1.innerHTML = "PHP";
    listTop.appendChild(head1);
    setTag(phpList);
}
function setTag(recordList){

    for (let index = 0; index < recordList.length; index++){

        const item = document.createElement('div'); 
        item.setAttribute('class', 'lm20 tm0, bm5'); 
        listTop.appendChild(item);
    
        //リンク
        const link = document.createElement('a');
        const href = '/lib/HTMLofText.html?filename='+recordList[index][3]+'&title='+recordList[index][1];
        link.setAttribute('href', href);
        link.setAttribute('target', '_blank');
        link.innerHTML = recordList[index][1];
        item.appendChild(link);
    }
}
// [2]は名称、[6]はスコア
//大小比較関数・名称の昇順  
function sortByNameA(l,r){
    return (r[2] < l[2]); 
}
//大小比較関数・名称の降順
function sortByNameD(l,r){
    return (r[2] > l[2]); 
}
