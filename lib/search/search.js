//HTMLタグの参照
const pgm = document.querySelector('#pgm');              //実行プログラム
const listTop = document.querySelector('#topOfList');    //結果レコードの先頭位置
const input = document.querySelector('#keyword');        //検索語
const button = document.querySelector('#search');        //検索ボタン
const searchTypes = document.getElementsByName('search_type');  //検索方法
const caseTypes = document.getElementsByName('case_type');    //大文字・小文字の区別
 
button.addEventListener('click', serarch);

let inText = "";  
let request = new XMLHttpRequest();
let keywords = [];
let caseFlag = "YES";

//リクエストの送信
function serarch(){
   //データ送信    

    //検索方法
    let searchType = 1;
    for (let i=0; i<searchTypes.length; i++){
        if (searchTypes[i].checked){
            searchType = searchTypes[i].value;
            break;
        }
    }
    //未入力
    if (input.value.trim().length == 0){
        return;
    }        
    let keywordList = "";
    if (searchType == 1){
    //入力した値をそのまま検索する
        keywords = [input.value];
        keywordList = "keyword[]="+input.value;  
    }else {
    //入力した値をスペースで分割しAND検索する
        const re = /\s+/;  //正規表現パターンオブジェクト：空白文字列
        keywords = input.value.split(re); //入力文字列を空白文字で分割し配列に格納
        //配列の要素からGETコマンドのパラメータ文字列を作成する
        for (let i = 0; i < keywords.length; i++){
            if (i==0){ 
                keywordList += "keyword[]="+keywords[i];
            }else{
                keywordList += "&keyword[]="+keywords[i];
            }
        }
    }
    //大文字・小文字の区別
    for (let i=0; i<caseTypes.length; i++){
        if (caseTypes[i].checked){
            caseFlag = caseTypes[i].value;
            break;
        }
    }
    keywordList += "&case="+caseFlag;
    //リクエストの送信
    request.open('GET', pgm.innerHTML+'?' + keywordList);
    request.timeout = 3000; //msec
    request.send();
}
//レスポンスの受信
request.onload = function(){
    let recordList = [];
    let READYSTATE_COMPLETED = 4;
    let HTTP_STATUS_OK = 200;
    if( this.readyState == READYSTATE_COMPLETED
        && this.status == HTTP_STATUS_OK ){
        //正常    
        let jsonText = request.responseText;
        console.log(jsonText);
        recordList = JSON.parse(jsonText);        
        //並べ替え
        recordList.sort(sortByCount);
        //既存のタグの削除    
        while(listTop.firstChild){
            listTop.removeChild(listTop.firstChild);
        }
        //タグの追加
        let grid = document.createElement('div');
        listTop.appendChild(grid);
        //レコード処理
        for (let record of recordList){        
            let item = document.createElement('div');   
            item.setAttribute('class', 'lm0 tm0');          
            grid.appendChild(item);   
            //カウント
            const count = document.createElement('span');
            count.setAttribute('class', 'lm10 font90');
            count.innerHTML = record["count"];
            item.appendChild(count);
            //パス
            const path = document.createElement('span');
            path.setAttribute('class', 'lm10 font90');
            path.innerHTML = record["folder"];
            item.appendChild(path);
            //リンク                      
            let keywordList = "";
            for (let i = 0; i < keywords.length; i++){
                keywordList += "&keyword="+keywords[i];
            }
            const url = '/lib/HTMLofTextSearch.html?filename='+record["url"]+'&title='+record["file"]+keywordList+'&case='+caseFlag;
            let anchor = document.createElement('a');
            anchor.setAttribute('class', 'lm10 font100');
            anchor.setAttribute('href', url);
            anchor.setAttribute('target', '_blank');
            anchor.innerHTML = record["file"];
            item.appendChild(anchor);

            //タイトル
            if (record["html"]){
                const title = document.createElement('a');
                title.setAttribute('class', 'lm10 font100');
                title.setAttribute('href', record["url"]);
                title.setAttribute('target', '_blank');
                title.innerHTML = record["title"];
                item.appendChild(title);
            }else{
                const title = document.createElement('span');
                title.setAttribute('class', 'lm10 font100');
                title.innerHTML = record["title"];
                item.appendChild(title);
            }
        }
    }else{
        alert('HTTPエラー status:'+this.status);
        return;
    }                   
}


//件数によるソート
function sortByCount(l,r){
    if (r["count"] > l["count"]){
        return true;
    }else if (r["count"] < l["count"]){
        return false;
    }else{
        if (r["file"] < l["file"]){
            return true;
        }else{
            return false;
        }    
    }
}

