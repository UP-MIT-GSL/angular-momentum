$(document).ready ->
  $.get("/api/messages/", (response) ->
    parsedResponse = JSON.parse(response)
    for id, message of parsedResponse
      messageBox = $("
        <div class='row'>
          <div class='span1 id'>
            <strong>ID</strong>
            <p>#{id}</p>
          </div>
          <div class='span3 message'>
            <strong>Message</strong>
            <p></p>
          </div>
        </div>
      ")
      messageBox.find(".message p").text message
      $("#messages").append messageBox
  ).fail (e) ->
    alert "Something went wrong."
