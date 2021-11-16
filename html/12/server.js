let express = require('express');
let mysql = require('mysql');
var app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
var pool = mysql.createPool({
    host: 'localhost',
    user: 'xxxx',
    password: 'xxxx',
    database: 'health'
});
var server = app.listen(5000, function () {
    console.log('Node server is running..');
});
//照会１
app.post('/sql_r10', function (req, res) {
    let id = req.body.id;
    let from_date = req.body.from_date;
    let to_date = req.body.to_date;
    let sql = `SELECT id, date, lower, upper, confirm ` +
              `FROM blood_pressure WHERE (id=${id}) AND ` +
              `(date >=${from_date} AND date <=${to_date})`;    
    doQuery(sql, res)
});
//照会２
app.post('/sql_r20', function (req, res) {
    let id = req.body.id;
    let date = req.body.date;
    let sql = `SELECT id, date, lower, upper, confirm ` +
              `FROM blood_pressure WHERE (id=${id}) AND (date=${date})`;
    doQuery(sql, res)
});
//追加・更新
app.post('/sql_w10', function (req, res) {
    let id = req.body.id;
    let date = req.body.date;
    let lower = req.body.lower;
    let upper = req.body.upper;
    let confirm = req.body.confirm;
    var count = 0;
    let sql1 = `SELECT COUNT(*) as count FROM blood_pressure ` + 
               `WHERE id=${id} AND date=${date}`;
    let sql2 = `UPDATE blood_pressure SET lower=${lower}, upper=${upper}, ` +
               `confirm=${confirm} WHERE id=${id} AND date=${date}`;  
    let sql3 = `INSERT INTO blood_pressure VALUES (${id}, ${date}, ` +
                `${lower}, ${upper}, ${confirm})`;
    pool.getConnection(function(err, connection){
        connection.query(sql1, (error, rows) =>{
            if (error){
                console.error(error);
            }else{
                connection.release();
                if (rows[0].count > 0){
                    doUpdate(sql2, res);   
                }else{
                    doUpdate(sql3, res);   
                }
            }
        });
    });
});    
//照会
function doQuery(sql, res){
    pool.getConnection(function(err, connection){
        connection.query(sql, (error, rows) =>{
            if (error){
                console.error(error);
            }else{
                res.setHeader('Content-Type', 'application/json');
                res.send(rows);
                connection.release();
            }
        });
    });
}
//追加・更新
function doUpdate(sql, res){
    pool.getConnection(function(err, connection){
        connection.query(sql, (error, rows) =>{
            if (error){
                console.error(error);
            }else{
                res.write(JSON.stringify([1])); 
                res.end();
                connection.release();
            }
        });
    });
}