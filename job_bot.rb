require "selenium-webdriver"
require "byebug"
require 'yaml'


class JobBot
		EMAIL = "aylanismello@gmail.com"
		PASSWORD = "L08181991d"
		APPLY_ID = "apply-job-button"
		JOBS_PAGE = "https://www.linkedin.com/jobs/?trk=nav_responsive_sub_nav_jobs"
		HOME = "https://linkedin.com"
		LOAD_TIME = 1
		PHONE_NUM = "415-608-8533"
		JOB_BATCH_NUM = 5
		PATH_TO_RESUME = '/Users/aylanmello/Documents/A.A/job/aylanmello_resume.pdf'

	def initialize

		config = YAML.load_file('config.yaml')
		byebug

		@driver = Selenium::WebDriver.for :chrome
		filename = "JobBot:".concat(Time.now.to_s[0..15].split(" ").join("&"))
		@file = File.open(filename, 'w')

		login
		get_job_links
		iterate_jobs
		@driver.quit
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
		@driver.navigate.to JOBS_PAGE
		puts @driver.current_url
		# byebug
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

		follow_radio_button = @driver.find_element(:name, 'followCompany')
		follow_radio_button.click

		phone_field = @driver.find_element(:name, 'phone')
		phone_field.send_keys PHONE_NUM

		resume_submit_button = @driver.find_element(:id, 'file-browse-input')
		resume_submit_button.send_keys(PATH_TO_RESUME)
		# wait for resume upload
		sleep(LOAD_TIME)

		puts "Applying to #{company}"


		@file.write("#{company}\n")

	end

	def is_job_acceptable?(apply_button, company_name_and_desc)
		apply_button.any? && !company_name_and_desc.downcase.include?('intern')
	end

	def iterate_jobs
		job_count = 0

		@jobs.each do |company, link|
			puts "going to #{company}"
			go_to(link)
			sleep(LOAD_TIME)
			apply_button = @driver.find_elements(:id, 'apply-job-button')
			job_apply(apply_button.first, company) if is_job_acceptable?(apply_button, company)
			job_count += 1
			break if job_count > JOB_BATCH_NUM
			sleep(LOAD_TIME)
		end

		@file.close
	end


end

JobBot.new
