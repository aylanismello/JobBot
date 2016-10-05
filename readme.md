## JobBot
### Making applying suck slightly less

**Installation**

* `git clone job_bot`
* `bundle install`
* Download latest version of chrome driver for appropriate OS [here](https://sites.google.com/a/chromium.org/chromedriver/downloads)
* Add the location of where you installed to your ENV path
variable by opening up your .bashrc (or .zshrc, etc) file
and adding the following line:
	`export PATH=$PATH:/chromedriver/location`
* run script in root directory with `ruby job_bot.rb`
