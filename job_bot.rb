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
		HOME = "https://linkedin.com"

	def initialize
		@driver = Selenium::WebDriver.for :chrome
		filename = "JobBot:".concat(Time.now.to_s[0..15].split(" ").join("&"))

		@file = File.open(filename, 'w') unless TESTING

		zip_bot
		# @driver.quit

	end

	def zip_bot
		@driver.navigate.to "https://www.ziprecruiter.com/login?realm=candidates"
		username = @driver.find_element(:name, 'email')
		username.send_keys 'aylanismello@gmail.com'
		password = @driver.find_element(:name, 'password')
		password.send_keys 'Z08181991r'

		submit_button = @driver.find_element(:name, 'submitted')
		submit_button.click

		all_jobs = @driver.find_elements(:class, 'job_content')
		jobs = []

		all_jobs.each do |job|
			apply_button = job.find_element(:css, '.apply_area > a')
			jobs << job if apply_button.text == "1-Click Apply"
		end

		jobs_applied_to

		jobs.each do |job|

			company_name = job.find_element(:class, 'hiring_company_name').text
			position = job.find_element(:class, 'panel_job_title').text
			location = job.find_element(:class, 'job_location').text
			apply_button = job.find_element(:css, '.apply_area > a')

			jobs_applied_to << "#{company_name}: #{position} - (#{location})"
			byebug
			
			apply_button.click

		end


		# name : title



	end



	def linkedin_bot
		login
		@driver.navigate.to JOBS_PAGE
		JOB_BATCH_NUM.times {show_more_jobs}
		get_job_links
		iterate_jobs

	end


	def login
		@driver.navigate.to HOME
		element = @driver.find_element(:class, 'login-email')
		element.send_keys EMAIL
		element = @driver.find_element(:class, 'login-password')
		element.send_keys PASSWORD
		element.submit
	end

	def get_job_links
		sleep(LOAD_TIME)

		puts @driver.title

		links = @driver.find_elements(:css,".item	> a").map{|link| link.attribute(:href)}
		companies = @driver.find_elements(:css,".job-info-container .col-right h3").map(&:text)
		titles = @driver.find_elements(:css,".job-info-container .col-right h2").map(&:text)
		companies = companies.map.with_index {|name, idx| name.concat(": #{titles[idx]}")}


		@jobs = {}
		companies.each.with_index do |company, idx|
			@jobs[company] = links[idx]
		end
	end

	def go_to(link)
		@driver.navigate.to link
	end

	def job_apply(apply_button, company)
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
			submit_app_button.click
			puts "Applied to #{company}"
			@file.write("#{company}\n")
		end

		sleep(LOAD_TIME)
	end

	def is_job_acceptable?(apply_button, company)
		apply_button.any? && FILTERS.none?{|filter| company.downcase.include?(filter)}
	end

	def show_more_jobs
		sleep(LOAD_TIME)
		expand_button = @driver.find_element(:class, 'expand-button')
		expand_button.click
		sleep(LOAD_TIME)
	end

	def iterate_jobs
		@jobs.each do |company, link|
			puts "going to #{company}"
			go_to(link)
			sleep(LOAD_TIME)
			apply_button = @driver.find_elements(:id, 'apply-job-button')
			job_apply(apply_button.first, company) if is_job_acceptable?(apply_button, company)
			sleep(LOAD_TIME)
		end


		@file.close unless TESTING
	end
end

JobBot.new
