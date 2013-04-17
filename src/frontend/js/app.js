$(document).ready(function(){
  $.get('/api/messages/', function(response){
    parsedResponse = JSON.parse(response);
    for (var id in parsedResponse) {
      var message = parsedResponse[id];
      var messageBox = $("<div class='row'>\
                            <div class='span1 id'>\
                              ID: <p>" + id + "</p>\
                            </div>\
                            <div class='span3 message'>\
                              Message: <p></p>\
                            </div>\
                          </div>\
                        ");
      messageBox.find(".message p").text(message);
      $("#messages").append(messageBox);
    }
  }).fail(function(e) {
    alert('Something went wrong.');
  });
});
