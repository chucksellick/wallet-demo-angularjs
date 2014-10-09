express = require('express');
app = express();

app.use(express.static(__dirname + '/app'));
app.get('/', (req, res)->
  res.sendFile('app/index.html')
);

app.listen(3000);
