"use strict";  
//グローバル変数    
let healthYear;     //当年
let healthMonth;    //当月
let inputYear;      //データ入力年
let inputMonth;     //データ入力月
let inputDay;       //データ入力日
let inputFromOpe=0; //データ入力フォームはどこから起動されたか？      

//定数   
const LARGE_SIZE = 42;
const REGULAR_SIZE = 35;
//HTML要素への参照    
const topLevel = document.querySelector('body.topLevel');       //body
const dataInputForm = document.querySelector('.INwrapper');     //入力フォーム
const searchForm = document.querySelector('.INwrapper2');       //検索フォーム
const thisYearMonth = document.querySelector('.thisYearMonth'); //年月タイトル     
const preButton = document.querySelector('.preButton');         //前月ボタン
const nxtButton = document.querySelector('.nxtButton');         //翌月ボタン
const inputButton = document.querySelector('#inputValue');      //入力ボタン
const resultButton = document.querySelector('#result');         //一覧表示ボタン
const inText = document.querySelector('#inText');               //入力テキスト

//変数    
let wk = new Date();                                         
let nowDt = new Date(wk.getFullYear(), wk.getMonth(), wk.getDate()); //当日(時刻を消去)
let baseDt =  new Date(wk.getFullYear(), wk.getMonth(), 1);         //月初日
let lastDt;
let positions = new Array();                                        //td要素参照リスト
let currentPos;                                                     //選択日
let isLargeTable;                                                   //カレンダーの大きさ
let holidaysList;                                                   //休日辞書
let valuesList;                                                     //データリスト

const midashi = document.querySelector('.INmidashi');               //日付タイトル     
const okButton = document.querySelector('#ok');                     //OKボタン
const cancelButton = document.querySelector('#cancel');             //Cancelボタン
window.load = setUp(); //ここからスタート

//イベントハンドラの設定
function setEventHandler(){
    //console.log('** setEventHandler');                       
    document.addEventListener('keydown', logKey);                   //キーボード入力
    preButton.addEventListener('click', preMonth);                  //前月へ
    nxtButton.addEventListener('click', nxtMonth);                  //翌月へ
    inputButton.addEventListener('click', requestOpenForm1);        //入力フォーム開く
    resultButton.addEventListener('click', openSearchPanel);        //検索フォーム
    for(let cell of positions){
        cell.addEventListener('click', dateClicked);                //選択日の移動
        cell.addEventListener('dblclick', requestOpenForm1);        //入力フォーム開く                   
    }
    document.removeEventListener('keydown', saveKey);               //キーボード入力(save)
}
//イベントハンドラの削除
function removeEventHandler(){
    //console.log('** removeEventHandler');                       
    document.removeEventListener('keydown', logKey);                //キーボード入力
    preButton.removeEventListener('click', preMonth);               //前月へ
    nxtButton.removeEventListener('click', nxtMonth);               //翌月へ
    inputButton.removeEventListener('click', requestOpenForm1);     //入力フォーム開く
    resultButton.removeEventListener('click', openSearchPanel);     //検索フォーム   
    for(let cell of positions){
        cell.removeEventListener('click', dateClicked);             //選択日の移動
        cell.removeEventListener('dblclick', requestOpenForm1);     //入力フォーム開く
    }
    document.addEventListener('keydown', saveKey);                  //キーボード入力(save)
}
//------------------------------------------------------------------------- 
//初期処理
//------------------------------------------------------------------------- 
function setUp(){
    //表示フォームの初期状態
    document.body.setAttribute("class", "topLevel");
    dataInputForm.style.display = 'none';
    searchForm.style.display = 'none';
    //リクエストの作成
    let request = new XMLHttpRequest()
    request.open('GET', 'holiday.json');
    //リクエストの送信
    request.send();
    //レスポンスの受信
    request.onload = function(){
        //休日ファイルの読み込み
        let jsonText = request.responseText;
        holidaysList = JSON.parse(jsonText); 
        //データの取得＆カレンダーの作成
        queryData(function(){makeCalendar(function(){
            setEventHandler();})});  
    }
}
//------------------------------------------------------------------------- 
//データの取得(query)
//------------------------------------------------------------------------- 
function queryData(funcMakeCalendar){
    //リクエストの作成
    let year = baseDt.getFullYear();
    let month = ("0"+(baseDt.getMonth()+1)).slice(-2);
    let days = new Date(year, month, 0).getDate();  
    //当年月
    healthYear = baseDt.getFullYear();
    healthMonth = baseDt.getMonth()+1;
    //データ入力年月
    inputYear = healthYear;
    inputMonth = healthMonth;
    let request = new XMLHttpRequest()
    request.open('POST', './php/sql_r20.php'); //
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    request.timeout = 3000; //msec
    let id=500;
    let from_date=`${year}${month}01`;
    let to_date=`${year}${month}${days}`;
    let param = `from_date=${from_date}&to_date=${to_date}`;        
    //リクエストの送信
    request.send(param);

    //レスポンスの受信
    request.onload = function(){
        let READYSTATE_COMPLETED = 4;
        let HTTP_STATUS_OK = 200;
        if( this.readyState == READYSTATE_COMPLETED
            && this.status == HTTP_STATUS_OK ){
            //正常・データ取得
            let jsonText = request.responseText;            
            valuesList = JSON.parse(jsonText);
            //カレンダーの作成
            funcMakeCalendar();
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
//------------------------------------------------------------------------- 
//カレンダーの作成
//------------------------------------------------------------------------- 
function makeCalendar(setCurrentPos){
    //年月見出し
    let seireki = baseDt.getFullYear()+'年'+(baseDt.getMonth()+1)+'月';
    let opt = {era:'short', year:'numeric'};
    let wareki = baseDt.toLocaleDateString("ja-JP-u-ca-japanese", opt);
    thisYearMonth.textContent = seireki+'('+wareki+')';
    //カレンダの作成
    let current = new Date(baseDt.getTime());     //月初日（オブジェクトの複製が必要）
    lastDt = new Date(baseDt.getFullYear(), baseDt.getMonth()+1, 0);    //月末日
    let daysList = new Array(LARGE_SIZE);   //日付リスト
    let preDays = current.getDay()-1;       //前月末の日数
    if (preDays < 0){ preDays = 6 };
    isLargeTable = (lastDt.getDate() + preDays > REGULAR_SIZE); //カレンダの大きさ
    current.setDate(current.getDate()-preDays); //前月の最終月曜日
    for (let i=0; i<daysList.length; i++){
        let items = new Object();
        items.date = current.getDate(); //日付のセット
        //当月日付の判定
        if (baseDt.getMonth() === current.getMonth()){
            items.month = "this";
        }else{
            items.month = "";
        } 
        //休日の判定
        if (current.getDay() == 0){
            items.day = "sunday";
        }else if (current.getDay() == 6){
            items.day = "saturday";
        }else{
            items.day = "";
        }    
        //当日の判定 
        if (baseDt.getMonth() === nowDt.getMonth()){
            //当月カレンダー
            if (current.getTime() === nowDt.getTime()){
            currentPos = i;            
            }
        }
        //休日の判定
        let yyyymmdd = current.getFullYear() + 
                    ("0"+(current.getMonth() + 1)).slice(-2) + 
                    ("0"+current.getDate()).slice(-2);
        let holiday = holidaysList[yyyymmdd];
        if(holiday !== void 0){
            items.holiday = holiday;
        }else{
            items.holiday = "";
        }
        //データ入力済みの判定
        items.sumi = false;
        for(let record of valuesList){
            if (record.date.toString() === yyyymmdd ){
                items.sumi = true;
                break;
            }
        } 
        //日付リストに追加
        daysList[i] = items;        
        current.setDate(current.getDate()+1);   //１日進める
    }
    //tableの編集
    let table = document.querySelector('table').tBodies[0];    
    let rowCount = table.rows.length;
    let cellCount = table.rows[0].cells.length;
    //日付のセット
    let idx = 0;
    positions　= []; //td要素参照テーブルのクリア
    for (let i=0; i<rowCount; i++){
        if (!isLargeTable && i==5){
                table.rows[i].hidden = true;
                break;
        }
        table.rows[i].hidden = false;
        for (let j=0; j<cellCount; j++){
            let cell = table.rows[i].cells[j];
            cell.removeAttribute('class');　//前回分をクリア
            positions.push(cell); //td要素への参照の確保
            cell.firstChild.textContent = daysList[idx].date;　　//日付のセット
            //休日
            if (daysList[idx].day == 'sunday' || daysList[idx].holiday !== ""){
                cell.classList.add('holiday');
            }else if  (daysList[idx].day == 'saturday'){
                cell.classList.add('saturday');
            }
            //当月日
            if (daysList[idx].month == 'this'){
                cell.classList.add('largeFont');
            }else{
                cell.classList.add('smallFont');
            }
            //血圧データ入力済みか
            if (daysList[idx].sumi){
                cell.classList.add('input');
            }else{
                cell.classList.add('noInput');
            }      
            cell.classList.add('day');          
            idx++;
        }
    }     
    setCurrentPos();
    movePosition(currentPos); 
}
//-------------------------------------------------------------------------    
//矢印キーによる選択日の移動（イベントプロシージャ）    
//------------------------------------------------------------------------- 
function logKey(e) {
    switch (e.code){
        case 'ArrowLeft':
            if (currentPos === 0) {
                preMonth(); //月初日は前月へ
                return;
            }
            currentPos--;
            movePosition();
        break;
        case 'ArrowRight':
            if ((isLargeTable &&  currentPos === LARGE_SIZE-1) || 
                (!isLargeTable && currentPos === REGULAR_SIZE-1)){
                nxtMonth(); //月末日は翌月へ
                return;
            };
            currentPos++;
            movePosition();
            break;
        case 'ArrowUp':
            if (currentPos <= 6) {return};
            currentPos -= 7;
            movePosition();
        break;
        case 'ArrowDown':
            if (isLargeTable){
                if (currentPos >= REGULAR_SIZE) {return};
            }else{
                if (currentPos >= REGULAR_SIZE-7) {return};
            }
            currentPos += 7;
            movePosition();
        break;
        case 'Comma':    
            if (e.shiftKey){
                preMonth(); //前月へ
            }
            break;
        case 'Period':    
            if (e.shiftKey){
                nxtMonth(); //前月へ
            }
            break;
        default:
            return;
    }
    movePosition(currentPos);
}
//------------------------------------------------------------------------- 
//選択日のハイライト
//------------------------------------------------------------------------- 
function movePosition(){
    for (let i=0; i<positions.length; i++){
        if (positions[i] === void 0){
            break;
        }
        if (i === currentPos){                 
            positions[i].classList.add('currentDay')
            inputDay = positions[currentPos].firstChild.textContent;
        }else{
            positions[i].classList.remove('currentDay')
        }
    }
}
//------------------------------------------------------------------------- 
//前月のカレンダー    
//------------------------------------------------------------------------- 
function preMonth(){
    baseDt =  new Date(baseDt.getFullYear(), baseDt.getMonth()-1, 1);   //前月初日
    //血圧データの取得＆カレンダーの作成            
    queryData(function(){
        makeCalendar(function(){
            if (isLargeTable){
                currentPos = LARGE_SIZE-1;
            }else{
                currentPos = REGULAR_SIZE-1;
            }
        })  
    });
}
//------------------------------------------------------------------------- 
//翌月のカレンダー    
//------------------------------------------------------------------------- 
function nxtMonth(){
    baseDt = new Date(baseDt.getFullYear(), baseDt.getMonth()+1, 1);   //翌月初日
    //血圧データの取得＆カレンダーの作成            
    queryData(function(){
        makeCalendar(function(){
            currentPos = 0;
        })  
    });
}    
//------------------------------------------------------------------------- 
//日付をクリックした
//------------------------------------------------------------------------- 
function dateClicked(e){
    for (let i=0; i<positions.length; i++){
        if (e.target === positions[i]){
            currentPos = i;
            movePosition()
            break;
        }
    }
}    
//------------------------------------------------------------------------- 
//検索フォーム
//------------------------------------------------------------------------- 
function openSearchPanel(e){
    removeEventHandler();
    document.body.setAttribute("class", "topLevel2");
    searchForm.style.display = "block";
    searchInit();
}
//------------------------------------------------------------------------- 
//入力フォーム表示
//------------------------------------------------------------------------- 
function requestOpenForm1(){
    inputFromOpe = 1;
    openForm();
}
//---------------------------------------------------------------------
//入力フォーム表示　イベントハンドラ
//---------------------------------------------------------------------
function openForm(){
    //イベントハンドラーの削除と登録
    okButton.removeEventListener('click', update);
    cancelButton.removeEventListener('click', cancel);
    okButton.addEventListener('click', update);
    cancelButton.addEventListener('click', cancel);

    document.body.setAttribute("class", "topLevel");
    dataInputForm.style.display = 'block';
    inText.value = "";
    if (inputFromOpe === 1){
        removeEventHandler(); //カレンダーのイベントハンドラ削除
    }else{
        searchForm.style.display = 'none';
    }
    //日付の表示
    let todayStr = `${inputYear}年${inputMonth}月${inputDay}日`; 
    midashi.textContent = todayStr;
    //データの取得
    let request = new XMLHttpRequest()
    request.open('POST', './php/sql_r10.php'); //
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    request.timeout = 3000; //msec
    let id=500;
    let yyyymmdd = `${inputYear}${('0'+inputMonth).slice(-2)}${('0'+inputDay).slice(-2)}`;
    let param = `date=${yyyymmdd}`;  
    console.log(param); 
    //リクエストの送信
    request.send(param);

    //非同期スレッド
    request.onload = function(){
        let READYSTATE_COMPLETED = 4;
        let HTTP_STATUS_OK = 200;
        if( this.readyState == READYSTATE_COMPLETED
            && this.status == HTTP_STATUS_OK ){
            let jsonText = request.responseText;
            let valuesList = JSON.parse(jsonText);
            //正常
            if (valuesList.length > 0){
                //カーソルをテキストの終端に位置付ける対応
                inText.value = ''; inText.focus(); 
                inText.value = valuesList[0]["text"];
            }else{
                //未入力
                inText.focus();
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
//入力データを更新する    
//---------------------------------------------------------------------
function update(e){
    //console.log('updated');
    let request = new XMLHttpRequest()
    if (inText.value.replace(/[\s|　]+/g, '').length === 0){
       //入力テキストが全て空白（半角スペース、全角スペース）のとき、既存のデータがあれば削除。
        inText.value = '';
        request.open('POST', './php/sql_w11.php'); 
    }else{
        request.open('POST', './php/sql_w10.php'); 
    }
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    request.timeout = 3000; //msec
    let yyyymmdd = `${inputYear}${('0'+inputMonth).slice(-2)}${('0'+inputDay).slice(-2)}`;
    let param = `date=${yyyymmdd}&text=${inText.value}`; 
    request.send(param);
    request.onload = function(){
        let READYSTATE_COMPLETED = 4;
        let HTTP_STATUS_OK = 200;
        if( this.readyState == READYSTATE_COMPLETED
            && this.status == HTTP_STATUS_OK ){
            //正常：データの取得＆カレンダー再作成
            let savePos = currentPos;
            queryData(function(){
                makeCalendar(function(){
                    currentPos = savePos; //これはすごい（が追えないな）
                })
            });  
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
//キャンセル（イベントプロシージャ）
//---------------------------------------------------------------------
function cancel(e){
    dataInputForm.style.display = 'none';
    if (inputFromOpe === 1){ 
        //カレンダーから起動
        setEventHandler(); //カレンダーのイベントハンドラの設定 
    }else{
        //入力フォームから起動
        searchForm.style.display = 'block';    
        document.body.setAttribute("class", "topLevel2");
        search();
    }
}
//---------------------------------------------------------------------
//更新（キー入力イベントプロシージャ） command+s
//---------------------------------------------------------------------
function saveKey(e){
    if (e.code === 'KeyS'){
        if (e.metaKey){
            e.preventDefault();
            update();
        }
    }
}