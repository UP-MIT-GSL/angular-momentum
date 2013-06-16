#!/bin/bash
set -e
BASEDIR=$(dirname $0)
cd $BASEDIR/..
npm install
npm install -g
bundle install
bundle exec rake
