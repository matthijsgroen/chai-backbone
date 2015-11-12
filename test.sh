#!/bin/bash
coffee -c -o . . && coffee -c -o test/ test/ && open test/browser/index.html

