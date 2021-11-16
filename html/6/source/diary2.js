//HTML要素への参照    
const searchYear = document.querySelector('.SearchYear');           //検索年
const searchMonth = document.querySelector('.SearchMonth');         //検索月
const searchNum = document.querySelector('.SearchNum');             //検索月数
const searchButton = document.querySelector('.SearchButton');       //検索ボタン
const searchText = document.querySelector('.SearchText');           //検索ワード
const closeButton = document.querySelector('.CloseButton');         //閉じるボタン
const listTop = document.querySelector('.listTop');                 //リストの先頭
const conditions = document.getElementsByName('cnd');               //ラジオボタン
//
searchButton.addEventListener('click', search);                     //検索
closeButton.addEventListener('click', close);                       //閉じる

//---------------------------------------------------------------------
// 初期処理
//---------------------------------------------------------------------
function searchInit(){
    //検索年月
    searchYear.value = healthYear;
    searchMonth.value = healthMonth;
    searchNum.value = 1; 
    conditions[0].checked = true;
    //表示エリアの初期化
    searchText.value = "";
    while(listTop.firstChild){
        listTop.removeChild(listTop.firstChild);
    }
    searchText.focus();
    search();
}
//---------------------------------------------------------------------
// 検索する    
//---------------------------------------------------------------------
function search(){
    //httpリクエスト定義
    let request = new XMLHttpRequest()   
    if (conditions[0].checked){
        request.open('POST', './php/sql_r51.php'); //OR条件 
    }else{
        request.open('POST', './php/sql_r52.php'); //AND条件 
    }
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    request.timeout = 3000; //msec
    //POSTパラメータの編集
    let from_date = firstDate(searchYear.value, searchMonth.value);
    let to_date = lastDate(searchYear.value, searchMonth.value, parseInt(searchNum.value));
    let keyword = searchText.value;
    //キーワードのトリミング：半角スペース、全角スペース
    keyword = keyword.replace(/^[\s|　]+|[\s|　]+$/g,'');
    let param = `from_date=${from_date}&to_date=${to_date}&keyword=${keyword}`; 
    //キーワードを空白文字で分割：検索語のハイライト表示で使用する
    let wordArray = new Array();
    if (keyword.match(/^[\s|　]*$/)){
            ;    
    }else{
        wordArray = keyword.split(/[\s|　]+/); 
    }
    request.send(param); //送信

    //受信（onloadイベントハンドラ）
    request.onload = function(){
        let READYSTATE_COMPLETED = 4;
        let HTTP_STATUS_OK = 200;
        if( this.readyState == READYSTATE_COMPLETED
            && this.status == HTTP_STATUS_OK ){
            //正常
            let jsonText = request.responseText;
            valuesList = JSON.parse(jsonText);
            //表示エリアの初期化
            while(listTop.firstChild){
                listTop.removeChild(listTop.firstChild) //(ここでイベントハンドラも消える)
            }
            if (valuesList.length === 0){
                let text = "Not Found";
                let element = document.createElement('p');
                element.setAttribute('class', 'notice');
                element.innerHTML = text;
                listTop.appendChild(element);
                return;
            }
            for (let record of valuesList){
                let element = document.createElement('p');
                element.setAttribute('class', 'date');
                let yyyy = record['date'].toString().substring(0,4);
                let mm = record['date'].toString().substring(4,6);
                let dd = record['date'].toString().substring(6,8);
                element.textContent = `${yyyy}年${mm}月${dd}日`;
                listTop.appendChild(element);
                element = document.createElement('p');
                element.setAttribute('class', 'text');
                element.setAttribute('id', `${yyyy}${mm}${dd}`);
                //イベントハンドラの設定：文章をダブルクリックして入力フォームを開く
                element.addEventListener('dblclick', requestOpenForm2);   
                //HTML編集
                let text = record['text'];
                text = text.replace(/\r?\n/g, '<br>'); //改行コードの変換 
                //検索語のハイライト表示
                wordArray.forEach(function(value) {
                    text = text.replace(new RegExp(value,"g"), '<span class="match">'+value+'</span>');
                });                
                element.innerHTML = text;  //テキストを設定・HTMLタグは認識される 
                //element.textContent = text; //誤・TMLタグは識別されずリテラルとしてそのまま表示される
                listTop.appendChild(element);
            }
        }else{
            alert('HTTPエラー status:'+this.status);
            return;
        }
    }
    //タイムアウト
    request.ontimeout = function () {
        alert("timed out.");
        return;
    };
}
//---------------------------------------------------------------------
//　文章をダブルクリックして入力フォームを開く
//---------------------------------------------------------------------
function requestOpenForm2(e){
    inputYear = this.id.substring(0,4);
    inputMontj = this.id.substring(4,6);
    inputDay = this.id.substring(6,8);
    inputFromOpe = 2;
    openForm();
}
//---------------------------------------------------------------------
//キャンセル（イベントプロシージャ）
//---------------------------------------------------------------------
function close(e){
    searchForm.style.display = 'none';
    setEventHandler();
}
//---------------------------------------------------------------------
//検索開始日を求める
//---------------------------------------------------------------------
function firstDate(year, month){
    let mm = (('0'+month).slice(-2));
    return year+mm+'01';
}
//---------------------------------------------------------------------
//検索終了日を求める
//---------------------------------------------------------------------
function lastDate(year, month, num){
    let date = new Date(year, month-1, 1, 0, 0); //基準日の初日
    date = new Date(date.getFullYear(), date.getMonth()+num, 0);
    yyyy = date.getFullYear();
    mm = ('0'+(date.getMonth()+1)).slice(-2);
    dd = ('0'+date.getDate()).slice(-2);
    return yyyy+mm+dd;
}
