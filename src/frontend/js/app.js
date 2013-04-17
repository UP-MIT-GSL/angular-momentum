$(document).ready(function(){
  $.get('/api/messages/', function(response){
    parsedResponse = JSON.parse(response);
    for (var id in parsedResponse) {
      var message = parsedResponse[id];
      var messageBox = $("<div class='row'>\
                            <div class='span1 id'>\
                              <strong>ID</strong>\
                              <p>" + id + "</p>\
                            </div>\
                            <div class='span3 message'>\
                              <strong>Message</strong>\
                              <p></p>\
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
