#!/bin/bash
set -e
BASEDIR=$(dirname $0)
cd $BASEDIR/..
pwd
npm install -g
bundle install
bundle exec rake
