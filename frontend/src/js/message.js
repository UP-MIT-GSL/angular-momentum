
var getID = function() {
  return $('.active .id').val();
}

// This kind of function declaration is the same as the above,
// except that the function is declared globally, wherever you
// put it, so we advise not to declare like this. We just did
// this for demonstration, and we won't use it again.
function getMessage() {
  return $('.active .message').val();
}

var setID = function(value) {
  $(".active .id").val(value);
}

var setMessage = function(value) {
  $(".active .message").val(value);
}


var select = function(tab) {
  // update the nav bar and the displayed tab
  $(".tab-pane").removeClass("active");
  $("#" + tab + "-pane").addClass("active");
  $(".nav-tabs > li").removeClass("active");
  $("#" + tab + "-nav").addClass("active");
}

$(document).ready(function() {

  $('#get-button').bind('click', function(e) {
    $.get('/api/messages/'+getID(), function(response) {
      setMessage(response);
    }).fail(function(e) {
      alert('Something went wrong. That ID may not exist.');
    });
  });

  $('#post-button').bind('click', function(e) {
    $.post('/api/messages',
      {message: getMessage()},
      function(response) {
        // Fill id box.
        setID(response);
        alert('Successfully made a message!');
      });
  });

  $('#put-button').bind('click', function(e) {
    // jQuery has no helper function for PUT requests.
    $.ajax({
      url: '/api/messages/'+getID(),
      type: 'PUT',
      data: {message: getMessage()}
    }).done(function(response) {
      alert('Successfully updated a message!');
    }).fail(function(response) {
      alert('Something went wrong.');
    });
  });

  $('#delete-button').bind('click', function(e) {
    $.ajax({
      url: '/api/messages/'+getID(),
      type: 'DELETE'
    }).done(function(response) {
      // Clear id and message boxes
      setID('');
      setMessage('');
      alert('Successfully deleted a message!');
    }).fail(function(response) {
      alert('Something went wrong. That ID may not exist.');
    });
  });

  $('.sample-form').submit(function() {
    // This prevents the page from refreshing when the form submits.
    return false;
  });
});
