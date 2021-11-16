const listTop = document.querySelector('#topOfList');    //要素の先頭位置
const button = document.querySelector('button');        //表示ボタン
const combo = document.querySelector('select.combo');        //表示ボタン

button.addEventListener('click', setUp);
let request = new XMLHttpRequest();

//リクエストの送信
function setUp(){
    //データ送信
    const code = combo.value;
    request.open('GET', 'test02.php?code=' + code);
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
        recordList = JSON.parse(jsonText);
    }else{
        alert('HTTPエラー status:'+this.status);
        return;
    }
    //既存のタグの削除    
    while(listTop.firstChild){
        listTop.removeChild(listTop.firstChild);
    }
    if (recordList.length == 0){
        const head1 = document.createElement('h3');    //HTMLタグの作成
        head1.innerHTML = "ありません";                        //表示テキスト
        listTop.appendChild(head1);                        //タグの追加
        return;
    }
    //見出しの出力
    let grid = document.createElement('div');
    grid.setAttribute('class', 'grid_form');
    listTop.appendChild(grid);
    //日付
    const head1 = document.createElement('div');    //HTMLタグの作成
    head1.setAttribute('class', 'head');            //属性の設定
    head1.innerHTML = "日付";                        //表示テキスト
    grid.appendChild(head1);                        //タグの追加
    //単価
    const head2 = document.createElement('div');    
    head2.setAttribute('class', 'head');            
    head2.innerHTML = "単価";                        
    grid.appendChild(head2);                     
    //数量
    const head3 = document.createElement('div');    
    head3.setAttribute('class', 'head');            
    head3.innerHTML = "数量";                        
    grid.appendChild(head3);                     
    //金額
    const head4 = document.createElement('div');    
    head4.setAttribute('class', 'head');            
    head4.innerHTML = "金額";                        
    grid.appendChild(head4);                     
    //加算
    let sum_quantity = 0;
    let sum_amount = 0;
    //一覧表の出力
    for (let i = 0; i < recordList.length; i++){
        //日付
        let item1 = document.createElement('div');   //HTMLタグの作成
        item1.setAttribute('class', 'col');         //属性の設定
        const dt = recordList[i]["date"].toString();
        const dtStr = dt.substr(0, 4)+"/"+dt.substr(4, 2)+"/"+dt.substr(6, 2); 
        item1.innerHTML = dtStr;                     //表示テキスト
        grid.appendChild(item1);                     //タグの追加
        //単価
        let item2 = document.createElement('div');   
        item2.setAttribute('class', 'col');         
        item2.innerHTML = recordList[i]["unit_price"].toLocaleString();      
        grid.appendChild(item2);                     
        //数量
        let item3 = document.createElement('div');   
        item3.setAttribute('class', 'col');         
        item3.innerHTML = recordList[i]["quantity"].toLocaleString();      
        grid.appendChild(item3);                     
        //金額
        let item4 = document.createElement('div');   
        item4.setAttribute('class', 'col');         
        item4.innerHTML = recordList[i]["amount"].toLocaleString();      
        grid.appendChild(item4);                     
        //加算
        sum_quantity += recordList[i]["quantity"];
        sum_amount += recordList[i]["amount"];

    }
    //合計の出力
    let sum1 = document.createElement('div');   //HTMLタグの作成
    grid.appendChild(sum1);                     //タグの追加
    let sum2 = document.createElement('div');   
    sum2.setAttribute('class', 'col');         
    sum2.innerHTML = "合計";      
    grid.appendChild(sum2);                     
    //数量
    let sum3 = document.createElement('div');   
    sum3.setAttribute('class', 'col');         
    sum3.innerHTML = sum_quantity.toLocaleString();      
    grid.appendChild(sum3);                     
    //金額
    let sum4 = document.createElement('div');   
    sum4.setAttribute('class', 'col');         
    sum4.innerHTML = sum_amount.toLocaleString();      
    grid.appendChild(sum4);                     
}