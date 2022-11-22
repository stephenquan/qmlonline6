# qmlonline6

This is the source code for Qt6 QML Online endpoint https://stephenquan.github.io/qmlonline/

This project allows you to try QML/JS code in your web browser.

 - It allows you to prototype small QML/JS code and see your code compile and run on the fly
 - It allows you to share code snippets (e.g. post snippets into StackOverflow, share on Teams or Slack or email)

It powered by Enscripten at Qt Web Assembly.

You will need Qt installation and Qt source code to build this repo.

To clone this repo, use:

    git clone https://github.com/stephenquan/qmlonline6.git
    git submodule init
    git submodule update

Script for compiling the Qt kit:

    scripts/mkqtwasm.sh
    
Script for compiling the qmlonline6 Web Assembly:

    scripts/mk.sh
    
Script for testing a local instance of qmlonline6 is:

    scripts/tst.sh
