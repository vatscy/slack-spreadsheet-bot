function doGet(req) {}

function doPost(req) {
  if (!req || !req.postData || !req.postData.contents) {
    return CreateResponse(req);
  }
  var arr = JSON.parse(req.postData.contents);

  var url = "https://docs.google.com/spreadsheets/d/1Wfgqedap7LdKq8_w9uVQXWasDDg1FUN-ruvTu1LZ754/edit#gid=0";
  var sheetName = "term2";

  var book = SpreadsheetApp.openByUrl(url);
  var sheet = book.getSheetByName(sheetName);

  arr.forEach((body, i, a) => {
    if (!body || !body.evaluatee || !body.eva || !body.text || !body.evaluator) {
      return CreateResponse(req);
    }

    var row = sheet.getLastRow() + 1;
    sheet.getRange(row, 1).setValue(body.evaluatee);
    sheet.getRange(row, 2).setValue(body.eva);
    sheet.getRange(row, 3).setValue(body.text);
    sheet.getRange(row, 4).setValue(body.evaluator);
    sheet.getRange(row, 5).setValue(new Date());
  });

  return CreateResponse(req);
}

function CreateResponse(body) {
  return ContentService.createTextOutput(JSON.stringify(body)).setMimeType(ContentService.MimeType.JSON);
}
