Tests for different weblocks components and environment for testing external components/widgets.

To execute tests do 3 things 

1. execute selenium-server
   This will start selenium-server-standalone which will control browser.
2. execute start-tests-server
   This will start weblocks test app and swank. No packages required to install, all
   packages must load from .quicklisp directory
3. execute (all-tests) or (weblocks-selenium-tests:all-tests) either in slime or in console.

This package contains environment for tests, selenium tests and two weblocks applications.
Applications are used for rendering widgets needed to be tested with selenium.  They are
similar, their main difference is javascript layer, one application is used for prototype
widgets, other is for jquery widgets.  You can use both applications for rendering and
testing your own weblocks widgets.

To add your own tests for your widgets using weblocks-selenium-tests environment you need
4 things.

* define page(s) containing demo of widget.
* start tests server with your test package included.
* define test suite(s) for your package
* define tests inside your test suite(s)

To define new page in demo list use weblocks-selenium-tests-app:define-demo-action (see
function documentation for details).  

To make sure it was defined and to run tests on it, you should tell
weblocks-selenium-tests about it.  This is done by running start-tests-server with test
packages as parameters.  You should care about loading corresponding .asd files
automatically before starting server (you can use .sbclrc for example or quicklisp with
.quicklisp/local-projects directory).

To define your own test suite use weblocks-selenium-tests:def-test-suite, it is similar to
stefil:defsuite*. Tests will be defined inside of all-tests suite which is root for
weblocks-selenium-tests.

You'll need also stefil:deftest and maybe some other stefil functions.

Other test helpers provided by weblocks-selenium-tests are
with-new-or-existing-selenium-session,
with-new-or-existing-selenium-session-on-jquery-site, require-firefox

Please refer to stefil or selenium documentation for more information. 


Package is tested only with sbcl.
