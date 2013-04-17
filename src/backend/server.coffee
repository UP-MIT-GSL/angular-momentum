# Welcome to our simple demo server!

express = require 'express' # Import express library

# This dummy database only lasts while the server is running.
# This is only for demonstration. Seriously, don't do anything like this.
database = 
  1: 'This is the first message!'
  2: 'This is the second message!'
databaseLength = 2


app = express() # Create an express application
app.use express.logger('dev') # Enable logging
app.use express.bodyParser() # Enable parsing POST parameters
app.use app.router # Use routing

# Function that maps to HTTP GET requests
# Example: accessing localhost:8080/api/messages/1
# Used in RESTful services to get objects
app.get '/api/messages/:id', (request, response, next) ->
  id = request.params['id']
  message = database[id]
  if message?
    response.send database[id]
  else
    next new Error('Message does not exist')

# Function that maps to HTTP GET requests
# Example: accessing localhost:8080/api/messages/
# Used in RESTful services to get objects
app.get '/api/messages/', (request, response, next) ->
  response.send JSON.stringify(database)

# Function that maps to HTTP POST requests
# Example: submitting forms with method POST to localhost:8080/api/messages/
# Used in RESTful services to create new objects
app.post '/api/messages', (request, response, next) ->
  message = request.body['message']
  database[++databaseLength] = message
  response.send databaseLength.toString()
  
# Function that maps to HTTP PUT requests
# Example: submitting forms with method PUT to localhost:8080/api/messages/1
# Used in RESTful services to update objects
app.put '/api/messages/:id', (request, response, next) ->
  id = request.params['id']
  message = request.body['message']

  if id of database
    database[id] = message
    response.send 'Updated the message!'
  else
    next new Error('Message does not exist')

# Function that maps to HTTP DELETE requests
# Example: submitting forms with method DELETE to localhost:8080/api/messages/1
# Used in RESTful services to delete objects
app.delete '/api/messages/:id', (request, response, next) ->
  id = request.params['id']
  if id of database
    delete database[id]
    response.send 'Deleted the message!'
  else
    next new Error('Message does not exist')

  
# Serve frontend directory as static files
app.use express.static(__dirname+'/../frontend/')

app.listen 8080 # Listens on port 8080
console.log 'Listening on port 8080...'
