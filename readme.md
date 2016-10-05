## JobBot
### Making applying suck slightly less

**Installation**

* `git clone`
* `bundle install`
* Download latest version of chrome driver for appropriate OS [here](https://sites.google.com/a/chromium.org/chromedriver/downloads)
* Add the location of where you installed to your ENV path
variable by opening up your .bashrc (or .zshrc, etc) file
and adding the following line:
	`export PATH=$PATH:/chromedriver/location`
* run script in root directory with `ruby job_bot.rb`


### Configurations (config.yam`l)
* Put all of your linked in login info under linked_in
* Add you phone number and the absolute path to your resume on your local machine
* Set keyword flags for jobs you don't want to apply to under *filters*
