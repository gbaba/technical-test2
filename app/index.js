const express = require('express');
const app = express();
const port = 3300;

app.get('/version', function (req, res) {
var response = {
    "myapplication": [
        {
        "version": "1.0",
        "lastcommitsha": "abc57858585",
        "description" : "pre-interview technical test"
        }
    ]
}
if (response.myapplication.length > 0) {
     res.send(response);
} else {
var errorObj = {
     httpCode: 404,
     message: 'NOT_FOUND',
     description: 'The resource referenced by request does not exists.',
     details: 'myapplication is not available'
}
res.status(404);
res.send(errorObj)
}
});
app.listen(port, function () {
   console.log("\nServer is running on port " + port);
});
module.exports = app;