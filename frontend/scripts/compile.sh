#!/bin/bash
set -e
BASEDIR=$(dirname $0)
cd $BASEDIR/..
pwd
npm install
bundle install
bundle exec rake
