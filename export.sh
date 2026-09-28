#!/bin/sh
mv .export/ants.html .export/index.html
zip  .export/ants.zip .export/*
butler push .export/ants.zip lochi-makes-games/ants:web

