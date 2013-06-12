# Welcome to our simple demo server!
import json # This is a library for encoding objects into JSON
from flask import Flask # This the microframework library we'll use to build our backend.

app = Flask(__name__)

# This dummy database only lasts while the server is running.
# This is only for demonstration. Seriously, don't do anything like this.
database = {
    1: 'This is the first message!',
    2: 'This is the second message!',
}
databaseLength = 2

# Function that maps to HTTP GET requests
# Example: accessing localhost:8080/messages/1
# Used in RESTful services to get objects
# By default, if we don't specify a methods attribute
# the handlers only respond to GET
@app.route('/messages/<int:id>/', strict_slashes=False)
def get_message(id):
    if id in database:
        return database[id]
    else:
        return 'Message does not exist', 404

# Function that maps to HTTP GET requests
# Example: accessing localhost:8080/messages/
# Used in RESTful services to get objects
@app.route('/messages/', strict_slashes=False)
def index_message():
    return json.dumps(database)

# Function that maps to HTTP POST requests
# Example: submitting forms with method POST to localhost:8080/messages/
# Used in RESTful services to create new objects
@app.route('/messages/', methods=['POST'], strict_slashes=False)
def post_message():
    message = request.form['message']
    databaseLength += 1
    database[databaseLength] = message
    return str(databaseLength)
    
# Function that maps to HTTP PUT requests
# Example: submitting forms with method PUT to localhost:8080/messages/1
# Used in RESTful services to update objects
@app.route('/messages/<int:id>/', methods=['PUT'], strict_slashes=False)
def put_message(id):
    message = request.form['message']
    if id in database:
        database[id] = message
        return 'Updated the message!'
    else:
        return 'Message does not exist', 404

# Function that maps to HTTP DELETE requests
# Example: submitting forms with method DELETE to localhost:8080/messages/1
# Used in RESTful services to delete objects
@app.route('/messages/<int:id>/', methods=['DELETE'], strict_slashes=False)
def delete_message(id):
    if id in database:
        del database[id]
        return 'Deleted the message!'
    else:
        return 'Message does not exist', 404

if __name__ == '__main__':
    print 'Listening on port 8080...'
    app.run(host='0.0.0.0', port=8080, debug=True)
