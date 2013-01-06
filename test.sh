#!/bin/bash
coffee -c -o . . && coffee -c -o test/ test/ && xdg-open test/browser/index.html

