
function getID(){
  return $('#id').val();
}

var getMessage = function(){
  // This is (almost) the same as the above declaration.
  return $('#message').val();
}

$(document).ready(function(){
  $('#get-button').bind('click', function(e){
    $.get('/api/messages/'+getID(), function(response){
      $('#message').val(response);
    }).fail(function(e){
      alert('Something went wrong. That ID may not exist.');
    });
  });

  $('#post-button').bind('click', function(e){
    $.post('/api/messages',
      {message: getMessage()},
      function(response){
        // Fill id box.
        $('#id').val(response);
        alert('Successfully made a message!');
      });
  });

  $('#put-button').bind('click', function(e){
    // jQuery has no helper function for PUT requests.
    $.ajax({
      url: '/api/messages/'+getID(),
      type: 'PUT',
      data: {message: getMessage()},
      success: function(response){
        alert('Successfully updated a message!');
      }
    });
  });

  $('#delete-button').bind('click', function(e){
    $.ajax({
      url: '/api/messages/'+getID(),
      type: 'DELETE',
      success: function(response){
        // Clear id and message boxes
        $('#id').val('');
        $('#message').val('');
        alert('Successfully deleted a message!');
      }
    });
  });

  $('#sample-form').submit(function(){
    // This prevents the page from refreshing when the form submits.
    return false;
  });
});
