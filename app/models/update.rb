class Update < ActiveRecord::Base
	belongs_to :course

	def self.reimageUpdatesForCourse(course_id)
		require "net/http"
require "json"
require "rubygems"
require "Date"

course = Course.find(course_id)
courseName = course.name
courseURL = course.syllabusLink

diffbotURLToken = ""
api = ""

courseName.gsub!(/\s+/, "")

case courseName
	when courseName = "CS106B"
        api = "CS106B"
  when courseName = "CS 106B"
	     api = "CS106B"
	when courseName = "CS103"
	    api = "CS103"
	when courseName = "CS106L"
	    api = "CS106L"
	when courseName = "CS166"
		api = "CS103"	
	when courseName = "CS110"
		api = "CS110"
	when courseName = "CS106A"
		api = "CS103"
	when courseName = "PWR1" || courseName = "PWR1CA"
		api = "PWR"
	else
		api = "CS103"
end	


diffBotParameter = "/api/" + api + "?token=73659789c3c2aa6d84fd9812b5ba57dc&url=" + courseURL


response = Net::HTTP.get_response("diffbot.com", diffBotParameter)
json = JSON.parse(response.body)

k = 0
	json["AnnouncementBody"]. each do |sivayetski|

		if api == "CS103"
	curHeader = json["AnnouncementHeader"][k+1]["Header"]
		else
	curHeader = json["AnnouncementHeader"][k]["Header"]
		end
	
	curDate = json["AnnouncementDate"][k]["Date"]
	curDescription = json["AnnouncementBody"][k]["Description"]

	exam = false
	hw = false

	if curDescription.match(/midterm/i)
		exam = true
	end
	if curDescription.match(/final/i)
		exam = true
	end	
	if curDescription.match(/exam/i)
		exam = true
	end
	if curDescription.match(/test/i)
		exam = true
	end

	if curDescription.match(/hw/i)
		hw = true
	end
	if curDescription.match(/assignment/i)
		hw = true
	end	
	if curDescription.match(/problem/i)
		hw = true
	end
	if curDescription.match(/homework/i)
		hw = true
	end

	update = Update.new(title: curHeader, date: Date.parse(curDate), body: curDescription, isHW: hw, isExam: exam, isPiazza: false)
	update.course = course
	update.save
	k = k + 1 
end

	end

end
