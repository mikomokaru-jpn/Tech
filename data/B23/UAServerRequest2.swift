class func postSyncJ(urlString:String, param:[String:Any])->Any
{
    //param: POSTパラメータを設定したディクショナリ
    //戻り値: レスポンスのJSON形式データをJSONSerializationによりJSONオブジェクトに変換して返す。

    var list:Any = []
    //パラメータをDataオブジェクトに変換
    let data: Data
    do {
        data =  try JSONSerialization.data(withJSONObject: param)
    }catch{
        print("JSONSerialization.data fatal error")
        return list
    }
    //URLリクエストオブジェクトの作成
    let url:URL = URL.init(string: urlString)!
    var request:URLRequest = URLRequest(url: url)
    //パラメータの設定
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type") 
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue(String(format:"%ld", data.count) , forHTTPHeaderField: "Content-Length")
    request.httpBody = data
    --------------------------------------------------------------------------
    コマンドの送受信処理は x-www-form-urlencoded形式のメソッドと全く同じなので以下省略
    --------------------------------------------------------------------------
     return list
}