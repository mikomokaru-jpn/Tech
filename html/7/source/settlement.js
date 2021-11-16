"use strict";
//------------------------------------------------------------------------- 
//グローバル変数
//------------------------------------------------------------------------- 
let recordList;         //レコードリスト  [連想配列の配列]
let saveRecordList;     //レコードリスト保存用  [連想配列の配列]
let tagList = [];       //要素への参照リスト   
let sortingFlag = "A"; 
const listTop = document.querySelector('#topOfList');           //要素の先頭位置
const updateButton = document.querySelector('button.update');   //更新ボタン
const sortButton = document.querySelector('button.sort');       //並び替えボタン
//------------------------------------------------------------------------- 
//ここからスタート
//------------------------------------------------------------------------- 
window.load = setUp(); 
//------------------------------------------------------------------------- 
//初期処理
//------------------------------------------------------------------------- 
function setUp(){
    getData(); //データ受信＆表示
    //イベントハンドラの設定
    updateButton.addEventListener('click', update);
    sortButton.addEventListener('click', sorting);
}
//------------------------------------------------------------------------- 
//データ受信＆表示
//------------------------------------------------------------------------- 
function getData(){
    let request = new XMLHttpRequest();
    request.open('POST', './php/sql_r10.php');
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    request.timeout = 3000; //msec
    let param = '';
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
            recordList = JSON.parse(jsonText);   //レコードリスト 
            saveRecordList = recordList.slice(); //退避
            setElements();  //表の編集・要素の追加
            displayList();  //レコードのセット
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
//データ送信する
//------------------------------------------------------------------------- 
function update(){
    //再計算
    reCalc(); 
    if(!confirm("データベースの更新を行いますか？")){
        //入力値を無効にする     
        recordList = saveRecordList;
        displayList();
        return;
    }
    //データ送信
    let jsonText = JSON.stringify(recordList);
    let request = new XMLHttpRequest();
    request.open('POST', './php/sql_w10.php');
    request.setRequestHeader( 'Content-Type', 'application/json');
    request.timeout = 3000; //msec
    //リクエストの送信
    request.send(jsonText);
    //レスポンスの受信
    request.onload = function(){
        let READYSTATE_COMPLETED = 4;
        let HTTP_STATUS_OK = 200;
        if( this.readyState == READYSTATE_COMPLETED
            && this.status == HTTP_STATUS_OK ){
            let jsonText = request.responseText;
            //更新正常・データ取得と再表示
            getData();
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
// 表の編集・要素の追加
//------------------------------------------------------------------------- 
function setElements(){
    //既存のタグの削除
    while(listTop.firstChild){
        listTop.removeChild(listTop.firstChild);
    }
    tagList = [] //要素への参照リストのクリア
    //親elementの追加
    let grid_form = document.createElement('div');
    grid_form.setAttribute('class', 'grid_form');
    listTop.appendChild(grid_form);
    //子elementの追加
    for (let i = 0; i < recordList.length; i++){
        let rowTag = {};
        //年
        const item1 = document.createElement('div');    //HTMLタグの作成
        item1.setAttribute('class', 'col1');            //属性の設定
        grid_form.appendChild(item1);                   //タグの追加
        rowTag.year = item1;                            //タグへの参照の保存
        //収入
        const item2 =  document.createElement('input');
        item2.setAttribute('type', 'text');
        item2.setAttribute('class', 'col2');
        //フォーカスが離れたとき、カンマを追加する。金額を再計算し再表示する　
        item2.addEventListener('blur', function(){ this.value = addComma(this.value); reCalc(); });
        //フォーカスが当たったとき、カンマを削除する。
        item2.addEventListener('focus', h_delComma); 
        grid_form.appendChild(item2);
        rowTag.income = item2;
        //支出
        const item3 =  document.createElement('input');
        item3.setAttribute('type', 'text');
        item3.setAttribute('class', 'col3');
        item3.addEventListener('blur', function(){ this.value = addComma(this.value); reCalc(); });
        item3.addEventListener('focus', h_delComma);       
        grid_form.appendChild(item3);
        rowTag.spending = item3;
        //次年度繰越
        const item4 =  document.createElement('div');
        item4.setAttribute('class', 'col4');
        grid_form.appendChild(item4);
        rowTag.amount = item4;
        //戸数
        const item5 =  document.createElement('input');
        item5.setAttribute('type', 'text');
        item5.setAttribute('class', 'col5');
        item5.addEventListener('blur', function(){ this.value = addComma(this.value); reCalc(); });
        item5.addEventListener('focus', h_delComma);       
        grid_form.appendChild(item5);
        rowTag.unit = item5;
        //人数    
        const item6 =  document.createElement('input');
        item6.setAttribute('type', 'text');
        item6.setAttribute('class', 'col6');
        item6.addEventListener('blur', function(){ this.value = addComma(this.value); reCalc(); });
        item6.addEventListener('focus', h_delComma);       
        grid_form.appendChild(item6);
        rowTag.population = item6;
        
        //リストに追加
        tagList.push(rowTag);
   }
}
//------------------------------------------------------------------------- 
//レコードのセット
//------------------------------------------------------------------------- 
function displayList(){
    for (let i = 0; i < recordList.length; i++){
        //年
        tagList[i].year.innerHTML = recordList[i]['year'];                
        //収入
        tagList[i].income.value = addComma(recordList[i]['income']);
        //支出
        tagList[i].spending.value = addComma(recordList[i]['spending']);
        //not work at the second time 
        //tagList[i].spending.setAttribute('value', addComma(recordList[i]['spending'])); 
        //次年度繰越
        tagList[i].amount.innerHTML = addComma(recordList[i]['amount']); 
        //戸数
        tagList[i].unit.value = addComma(recordList[i]['unit']);
        //人数    
        tagList[i].population.value = addComma(recordList[i]['population']);
   }
}
//------------------------------------------------------------------------- 
//再計算
//-------------------------------------------------------------------------
function reCalc(){  
    recordList = [];
    for (let i=0; i<tagList.length; i++){
        let record = {}; 
        let row = tagList[i];
        //年
        record.year = row.year.innerHTML; 
        //収入
        const income = Number(delComma(row.income.value));
        if (!Number.isInteger(income)){ //ニューメリックチェック
            row.income.value = '';
            row.income.focus();
            return;
        }
        record.income = income;
        //支出
        const spending = Number(delComma(row.spending.value));
        if (!Number.isInteger(spending)){
            row.spending.value = '';
            row.spending.focus();
            return;
        }
        record.spending = spending;
        //次年度繰越
        record.amount = delComma(row.amount.innerHTML);
        //戸数
        const unit = Number(delComma(row.unit.value));
        if (!Number.isInteger(unit)){
            row.unit.value = '';
            row.unit.focus();
            return;
        }
        record.unit = unit;
        //人数
        const population = Number(delComma(row.population.value));
        if (!Number.isInteger(population)){
            row.population.value = '';
            row.population.focus();
            return;
        }
        record.population = population;
        //リストに追加
        recordList.push(record);
    }
    //金額の再計算
    for (let i = 0; i < recordList.length; i++){
        let preAmount = 0
        if (i > 0){
            preAmount = recordList[i-1]["amount"]; //前年繰越
        }
        recordList[i]["amount"] = preAmount + 
                                  recordList[i]["income"] - 
                                  recordList[i]["spending"];  
    }
    displayList();
}
//------------------------------------------------------------------------- 
//カンマ追加
//------------------------------------------------------------------------- 
function addComma(value){
    if (value == ''){
        return '';
    }
    return String(value).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');  //Stringオブジェクトが必要
    //return String(value).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}
//------------------------------------------------------------------------- 
//カンマ削除
//------------------------------------------------------------------------- 
function h_delComma(){
    this.value = delComma(this.value) 
} 
function delComma(value){
    if (value == ''){
        return '';
    }
    return value.replace( /,/g, '');
}
//------------------------------------------------------------------------- 
//並べ替え
//------------------------------------------------------------------------- 
function sorting(){
    if (sortingFlag == 'A'){
        recordList.sort(function(a,b){
            return (b.year - a.year); //年で降順
        });            
        displayList(); //表の再表示
        sortingFlag = 'D';
    }else{
        recordList.sort(function(a,b){
            return (a.year - b.year); //年で昇順
        });
            displayList(); //表の再表示
        sortingFlag = 'A';
    }
}