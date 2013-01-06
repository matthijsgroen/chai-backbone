#!/bin/bash
xdg-open test/browser/index.html
coffee -cw -o . . & coffee -cw -o test/ test/

