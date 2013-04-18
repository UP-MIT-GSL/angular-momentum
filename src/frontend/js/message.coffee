getID = ->
  $(".active .id").val()

getMessage = ->
  $(".active .message").val()

setID = (value) ->
  $(".active .id").val value

setMessage = (value) ->
  $(".active .message").val value

select = (tab) ->
  # update the nav bar and the displayed tab
  $(".tab-pane").removeClass "active"
  $("##{tab}-pane").addClass "active"
  $(".nav-tabs > li").removeClass "active"
  $("##{tab}-nav").addClass "active"

$(document).ready ->
  $("#get-button").bind "click", (e) ->
    $.get("/api/messages/#{getID()}", (response) ->
      setMessage response
    ).fail (e) ->
      alert "Something went wrong. That ID may not exist."


  $("#post-button").bind "click", (e) ->
    $.post "/api/messages",
      message: getMessage()
    , (response) ->
      # Fill id box.
      setID response
      alert "Successfully made a message!"


  $("#put-button").bind "click", (e) ->
    # jQuery has no helper function for PUT requests, so
    # we use the less convenient but more general $.ajax
    # function
    $.ajax(
      url: "/api/messages/#{getID()}"
      type: "PUT"
      data:
        message: getMessage()
    ).done((response) ->
      alert "Successfully updated a message!"
    ).fail (response) ->
      alert "Something went wrong."


  $("#delete-button").bind "click", (e) ->
    # Clear id and message boxes
    $.ajax(
      url: "/api/messages/#{getID()}"
      type: "DELETE"
    ).done((response) ->
      setID ""
      setMessage ""
      alert "Successfully deleted a message!"
    ).fail (response) ->
      alert "Something went wrong. That ID may not exist."


  $(".sample-form").submit ->
    # This prevents the page from refreshing when the form submits.
    false
