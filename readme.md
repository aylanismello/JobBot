## JobBot

![gif](http://res.cloudinary.com/dfkrjl3pb/image/upload/v1476654999/ezgif.com-video-to-gif_cpumze.gif)

***Experimental feature (10.16.2016): Integration with ZipRecruiter***


**Installation**

* `git clone`
* `bundle install`
* Download latest version of chrome driver for appropriate OS [here](https://sites.google.com/a/chromium.org/chromedriver/downloads)
* Add the location of where you installed to your ENV path
variable by opening up your .bashrc (or .zshrc, etc) file
and adding the following line:
	`export PATH=$PATH:/chromedriver/location`
* run script in repo directory with `ruby job_bot.rb -l` or `ruby job_bot.rb -z` for zip recruiter

*Jobs applied to are saved to log files created in the root repo directory
in the format JobBot:YYYY-MM-DD&HH:MM*Â

### config.yaml
`linked_in`

* `EMAIL / PASSWORD` Put your linked in login credentials here

* `PHONE NUMBER` You need your phone number to apply

* `RESUME_PATH` The absolute path to your resume on your local machine

`zip_recruiter`
*  `EMAIL / PASSWORD` Put your zip recruiter login credentials here

* `BATCH_NUM` choose how many times you want zip recruiters to refresh 'suggested jobs' page and keep applying

`settings`

* `FILTERS` Set keyword flags for jobs you don't want to apply to under *filters*

* `FOLLOW_COMPANIES` Set to false if you don't want to auto follow companies you apply to

* `LOAD_TIME` time between selenium actions. adjust according to speed of internet connection
