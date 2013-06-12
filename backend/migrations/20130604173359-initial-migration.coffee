dbm = require 'db-migrate'
type = dbm.dataType

exports.up = (db, callback) ->
  # This migration does nothing.
  callback()

exports.down = (db, callback) ->
  # This migration does nothing too.
  callback()
