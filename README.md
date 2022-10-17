# qmlonline6

This is the source code for Qt6 QML Online endpoint https://stephenquan.github.io/qmlonline/
It uses Enscripten at Qt Web Assembly.
You will need Qt installation and Qt source code to build this repo.

Script for compiling the Qt kit is in the `scripts/mkqtwasm.sh`
Script for compiling the qmlonline6 Web Assembly is `scripts/mk.sh`
Script for testing a local instance of qmlonline6 is in `scripts/tst.sh`

To clone this repo, use:

    git clone https://github.com/stephenquan/qmlonline6.git
    git submodule init
    git submodule update
