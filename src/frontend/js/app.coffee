$(document).ready ->
  $.get("/api/messages/", (response) ->
    # The response given by the backend is a string
    # in JSON (Javascript Object Notation) format, so
    # we convert it into an actual Javascript object.
    # JSON should look familiar to people with Java,
    # C/C++, Javascript background.
    parsedResponse = JSON.parse(response)
    for id, message of parsedResponse
      # For each message, we construct a new element
      # containing that message ...
      messageBox = $("<div class='row'>
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

      # ... and append it to the "#messages" element
      $("#messages").append messageBox
  ).fail (e) ->
    alert "Something went wrong."
