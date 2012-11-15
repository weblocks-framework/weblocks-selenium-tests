Tests for different weblocks components in future.
Currently only one test available.

To execute tests do 3 things 

1. execute selenium-server
   This will start selenium-server-standalone which will control browser.
2. execute start-tests-server
   This will start weblocks test app and swank. No packages required to install, all packages must load from .quicklisp directory
3. execute (all-tests) or (weblocks-selenium-tests:all-tests) either in slime or in console.

NOTE: Before start testing with firefox make sure it opens properly with "-profile misc/selenium-firefox-profile/" params.
