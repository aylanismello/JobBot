## JobBot

![gif](http://im2.ezgif.com/tmp/ezgif-1098154881.gif)

**Installation**

* `git clone`
* `bundle install`
* Download latest version of chrome driver for appropriate OS [here](https://sites.google.com/a/chromium.org/chromedriver/downloads)
* Add the location of where you installed to your ENV path
variable by opening up your .bashrc (or .zshrc, etc) file
and adding the following line:
	`export PATH=$PATH:/chromedriver/location`
* run script in repo directory with `ruby job_bot.rb`

*Jobs applied to are saved to log files created in the root repo directory
in the format JobBot:YYYY-MM-DD&HH:MM*

### config.yaml
`EMAIL / PASSWORD` Put your linked in login credentials here

`PHONE NUMBER` You need your phone number to apply

`RESUME_PATH` The absolute path to your resume on your local machine

`FILTERS` Set keyword flags for jobs you don't want to apply to under *filters*

`FOLLOW_COMPANIES` Set to false if you don't want to auto follow companies you apply to

`LOAD_TIME` time between selenium actions. adjust according to speed of internet connection
