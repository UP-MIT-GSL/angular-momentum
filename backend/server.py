# Welcome to our simple demo server!
import json # This is a library for encoding objects into JSON
from flask import Flask, request # This the microframework library we'll use to build our backend.
import sqlalchemy
from models import Message
from database import db_session, db_init

app = Flask(__name__)
db_init()

# Function that maps to HTTP GET requests
# Example: accessing localhost:8080/messages/1
# Used in RESTful services to get objects
# By default, if we don't specify a methods attribute
# the handlers only respond to GET
@app.route('/messages/<int:id>/', strict_slashes=False)
def get_message(id):
    try:
        message = db_session.query(Message).filter_by(id=id).one()
        return message.message
    except sqlalchemy.orm.exc.NoResultFound:
        return 'Message does not exist', 404

# Function that maps to HTTP GET requests
# Example: accessing localhost:8080/messages/
# Used in RESTful services to get objects
@app.route('/messages/', strict_slashes=False)
def index_message():
    messages = db_session.query(Message).all()
    jsonable = [{'id': msg.id, 'message': msg.message} for msg in messages]
    return json.dumps(jsonable)

# Function that maps to HTTP POST requests
# Example: submitting forms with method POST to localhost:8080/messages/
# Used in RESTful services to create new objects
@app.route('/messages/', methods=['POST'], strict_slashes=False)
def post_message():
    message = request.form['message']
    msg = Message(message=message)
    db_session.add(msg)
    db_session.commit()
    return str(msg.id)
    
# Function that maps to HTTP PUT requests
# Example: submitting forms with method PUT to localhost:8080/messages/1
# Used in RESTful services to update objects
@app.route('/messages/<int:id>/', methods=['PUT'], strict_slashes=False)
def put_message(id):
    try:
        message = db_session.query(Message).filter_by(id=id).one()
        message.message = request.form['message']
        db_session.add(message)
        db_session.commit()
        return 'Updated the message!'
    except sqlalchemy.orm.exc.NoResultFound:
        return 'Message does not exist', 404

# Function that maps to HTTP DELETE requests
# Example: submitting forms with method DELETE to localhost:8080/messages/1
# Used in RESTful services to delete objects
@app.route('/messages/<int:id>/', methods=['DELETE'], strict_slashes=False)
def delete_message(id):
    try:
        message = db_session.query(Message).filter_by(id=id).one()
        db_session.delete(message)
        db_session.commit()
        return 'Deleted the message!'
    except sqlalchemy.orm.exc.NoResultFound:
        return 'Message does not exist', 404

if __name__ == '__main__':
    print 'Listening on port 8080...'
    app.run(host='0.0.0.0', port=8080, debug=True)
