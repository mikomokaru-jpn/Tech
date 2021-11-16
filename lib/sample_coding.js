"use strict";
let masterList = [
[1, "NSString", "nsstring", "/sample1/1/sample.txt", 0, 1],
[2, "String", "string", "/sample1/2/sample.txt", 1, 0],
[3, "フォーマット指定子" , "フオーマットシテイシ", "/sample1/3/sample.txt", 0, 1],
[4, "文字列のニューメリックチェック", "モジレツノニューメリック", "/sample1/4/sample.txt", 0, 1],
[5, "NSNumber", "nsnumber", "/sample1/5/sample.txt", 0, 1],
[6, "NSArray", "nsarray", "/sample1/6/sample.txt", 0, 1],
[7, "NSDictionary", "nsdictionary", "/sample1/7/sample.txt", 0, 1],
[8, "NSValue （NSRectの配列 / 構造体の配列）", "navalue", "/sample1/8/sample.txt", 0, 1],
[9, "マウスイベントを取得する", "マウスイベントヲシュトク", "/sample1/9/sample.txt", 1, 1],
[10, "ウィンドウのコンテントビューに含まれるNSViewオブジェクトを全て取得する", "ウィンドウノコンテントビ", "/sample1/10/sample.txt", 0, 1],
[11, "ビューにイメージを表示するとき、イメージのサイズを正規化する", "ビューニイメージヲヒョウ", "/sample1/11/sample.txt" , 0, 1],
[12, "ファイルを読み込む", "ファイルヲヨミコム", "/sample1/12/sample.txt" , 0, 1],
[13, "NSURL / URL", "nsurl / url", "/sample1/13/sample.txt" , 1, 1],
[14, "AppDelegateを参照する", "appdelegateヲサンショウ", "/sample1/14/sample.txt", 1, 0],
[15, "NSFileManager/ FileManager / FileHandle", "nsfileManager/ fileManager / fileHandle", "/sample1/15/sample.txt" , 1, 1],
[16, "ユーザデフォルト", "ユーザデフォルト", "/sample1/16/sample.txt" , 1, 1],

[18, "NSDate", "nsdate", "A10/source/18.txt", 0, 1],
[19, "数学関数（乱数、三角関数）", "スウガクカンスウ", "/sample1/19/sample.txt" , 1, 1],
[20, "for文 配列に対する繰り返し処理", "forブン ハイレツニタイスルク", "/sample1/20/sample.txt", 1, 0],
[21, "計算型プロパティ", "ケイサンガタプロパティ", "/sample1/21/sample.txt" , 1, 0],
[22, "try文", "tryブン", "/sample1/22/sample.txt", 1, 0],
[23, "オブジェクトのクラスを判定する", "オブジェクトノクラスヲハ", "/sample1/23/sample.txt", 1, 0],
[24, "ビューのY軸の反転", "ビューノYジクノハンテン", "/sample1/24/sample.txt", 1, 1],

[26, "descriptionを表示する", "descriptionヲヒョウジスル", "/sample1/26/sample.txt", 1, 0],

[28, "JSON文字列をJSONオブジェクトに変換する", "jsonモジレツヲJjso", "/sample1/28/sample.txt", 1, 0],
[29, "enum型", "enumガタ", "/sample1/29/sample.txt", 1, 0],
[30, "escキー押下時でウィンドウを閉じる", "escキーオウカジデウィ", "/sample1/30/sample.txt", 1, 0],
[31, "NSAlert", "nsalert", "/sample1/31/sample.txt", 1, 0],
[32, "アクティブでないビューをクリックしたときに即反応する", "アクティブデナイビューヲ", "/sample1/32/sample.txt", 1, 0],
[33, "マウスポインターの形状を変更する", "マウスポインターノケイジ", "/sample1/33/sample.txt", 1, 0],
[34, "クラスを判定する", "クラスヲハンテイスル", "/sample1/34/sample.txt", 1, 0],
[35, "スクリーンの大きさを取得する", "スクリーンノオオキサヲシ", "/sample1/35/sample.txt", 1, 0],
[36, "アプリケーションを指定してファイルを開く", "アプリケーションヲシテイ", "/sample1/36/sample.txt", 1, 1],
[37, "処理時間を測定する", "ショリジカンヲソクテイス", "/sample1/37/sample.txt", 1, 0],
[38, "メインバンドルからファイルを読み込む", "メインバンドルカラファイ", "/sample1/38/sample.txt", 1, 0],
[39, "ログをテキストファイルに出力する", "ログヲテキストファイ", "/sample1/39/sample.txt", 1, 0],
[40, "NSButton", "nsbutton", "/sample1/40/sample.txt", 1, 0],

[42, "Array（配列）", "array", "/sample1/42/sample.txt", 1, 0],
[43, "Dictionary（辞書）", "dictionary", "/sample1/43/sample.txt", 1, 0],
[44, "key操作イベントの取得", "keyソウサイベントノシュトク", "/sample1/44/sample.txt", 1, 0]


];
let recordList = [];
const listTop = document.querySelector('#ListTop');                     //要素の先頭位置
const selectKind = document.querySelector('select.combo');              //コンボボックス・種類

//開始
window.onload = function(){ 
    //イベントハンドラの設定
    selectKind.addEventListener('change', changeKind);
    //初期処理
    setUp();
}

//ソート＆表示
function setUp(){
    recordList = masterList;
    recordList.sort(sortByNameA);
    displayList();
}

//イベントハンドラ・種類の選択　
function changeKind(event){
    selectData(event.currentTarget.value);
}
//種類で絞り込み
function selectData(value){
    if (value == "both"){
        recordList = masterList;
    }else{
        recordList = [];
        for (let i = 0; i < masterList.length; i++){
            if (value == "Swift"){
                if (masterList[i][4] == 1){
                    recordList.push(masterList[i]);    
                }        
            }else if (value == "Objective-C"){
                if (masterList[i][5] == 1){
                    recordList.push(masterList[i]);    
                }        
            } 
        }
    }
    recordList.sort(sortByNameA);
    displayList();
}
//一覧表示
function displayList(){

     console.log("displayList");
    //既存のタグの削除
    while(listTop.firstChild){
        listTop.removeChild(listTop.firstChild);
    }
    for (let i = 0; i < recordList.length; i++){
        const item = document.createElement('div'); 
        item.setAttribute('class', 'lm20 tm5'); 
        listTop.appendChild(item);
        
        const kind1 = document.createElement('span');
        kind1.setAttribute('class', 'inlineblock w15 font90');
        if (recordList[i][4] == 1){
            kind1.innerHTML = "◎"; 
        }else{
            kind1.innerHTML = "";
        }
        item.appendChild(kind1);        
        const kind2 = document.createElement('span');
        kind2.setAttribute('class', 'inlineblock w20 font90'); 
        if (recordList[i][5] == 1){
            kind2.innerHTML = "●"; 
        }else{
            kind2.innerHTML = "";
        }
        item.appendChild(kind2);                
        //リンク
        const link = document.createElement('a');
        const href = '/lib/HTMLofText.html?filename='+recordList[i][3]+'&title='+recordList[i][1];
        link.setAttribute('href', href);
        link.setAttribute('target', '_blank');
        link.innerHTML = recordList[i][1];
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
