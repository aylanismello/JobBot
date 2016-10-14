#!/usr/bin/env ruby
require "selenium-webdriver"
require "byebug"
require 'yaml'

class JobBot
		CONFIG = YAML.load_file('config.yaml')

		EMAIL = CONFIG['linked_in']['email']
		PASSWORD = CONFIG['linked_in']['password']
		PHONE_NUM = CONFIG['linked_in']['phone_num']
		PATH_TO_RESUME = CONFIG['linked_in']['resume_path']


		FILTERS = CONFIG['settings']['filters'].map(&:downcase)
		TESTING = CONFIG['settings']['testing']
		LOAD_TIME = CONFIG['settings']['load_time']
		FOLLOW_COMPANIES = CONFIG['settings']['follow_companies']
		JOB_BATCH_NUM = 2
		APPLY_ID = "apply-job-button"
		JOBS_PAGE = "https://www.linkedin.com/jobs/?trk=nav_responsive_sub_nav_jobs"
    # second jobs page is a direct link to a linkedIn job search for postings containing 'front end' within the last 24 hours.
    JOBS_PAGE2 = "https://www.linkedin.com/jobs/search?keywords=Front+End&locationId=us%3A84&f_TP=1&orig=FCTD&trk=jobs_jserp_posted_one_day"
		HOME = "https://linkedin.com"

	def initialize
		@driver = Selenium::WebDriver.for :chrome
		filename = "JobBot:".concat(Time.now.to_s[0..15].split(" ").join("&"))
		@file = File.open(filename, 'w') unless TESTING
    puts "Where to? 1 for linkedin, 2 for indeed"
    @destination = gets.to_i;
		login
    navigate_to_jobs
    # Edge case needed: postings within the last 24 hours usually have < 4 pages total, hence 3 used here.
		3.times {
      show_more_jobs
		  get_job_links
  }
		iterate_jobs
		@driver.quit
	end

	def login
    if @destination == 1
  		@driver.navigate.to HOME
  		element = @driver.find_element(:class, 'login-email')
  		element.send_keys EMAIL
  		element = @driver.find_element(:class, 'login-password')
  		element.send_keys PASSWORD
  		element.submit
    else
      # Navigate to indeed. 
      @driver.navigate.to "https://secure.indeed.com/account/login?service=my&hl=en_US&co=US&continue=http%3A%2F%2Fwww.indeed.com%2F"
      element = @driver.find_element(:id, 'signin_email')
      element.send_keys EMAIL
      element = @driver.find_element(:id, 'signin_password')
      element.send_keys PASSWORD
      element.submit
    end
	end

  def navigate_to_jobs
    @driver.navigate.to JOBS_PAGE2
  end


	def get_job_links
		sleep(LOAD_TIME)

		puts @driver.title

		links = @driver.find_elements(:css,".job-title	> a").map{|link| link.attribute(:href)}
		companies = @driver.find_elements(:css,".job-info-container .col-right h3").map(&:text)
		titles = @driver.find_elements(:css,".job-info-container .col-right h2").map(&:text)
		companies = companies.map.with_index {|name, idx| name.concat(": #{titles[idx]}")}

		@jobs = links
		companies.each.with_index do |company, idx|
			idx = links[idx]
		end
	end

	def go_to(link)
		@driver.navigate.to link
	end

	def job_apply(apply_button, company=nil)
		apply_button.click
		sleep(LOAD_TIME)

		if !FOLLOW_COMPANIES && !company.include?('linkedin')
			follow_radio_button = @driver.find_element(:name, 'followCompany')
			follow_radio_button.click
		end

		phone_field = @driver.find_element(:name, 'phone')
		phone_field.clear
		phone_field.send_keys PHONE_NUM

		resume_submit_button = @driver.find_element(:id, 'file-browse-input')
		resume_submit_button.send_keys(PATH_TO_RESUME)
		sleep(LOAD_TIME)

		submit_app_button = @driver.find_element(:id, 'send-application-button')

		unless TESTING
      sleep 3
			submit_app_button.click
			puts "Applied to #{company}"
			@file.write("#{company}\n")
		end

		sleep(LOAD_TIME)
	end

	def is_job_acceptable?(apply_button, company = "nil")
		apply_button.any? && FILTERS.none?{|filter| company.downcase.include?(filter)}
	end

	def show_more_jobs
		sleep(LOAD_TIME)
		expand_button = @driver.find_element(:class, 'next-btn')
		expand_button.click
		sleep(LOAD_TIME)
	end

	def iterate_jobs
		# job_count = 0
    sleep 6
		@jobs.each do |link|
			# puts "going to #{company}"
			go_to(link)
      sleep 3
      name = @driver.find_element(:class, "company").text
			sleep(LOAD_TIME)
			apply_button = @driver.find_elements(:id, 'apply-job-button')
			job_apply(apply_button.first, name) if is_job_acceptable?(apply_button)
			sleep(LOAD_TIME)
		end

		@file.close unless TESTING
	end
end

JobBot.new
