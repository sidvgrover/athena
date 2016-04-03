class AnnouncementsController < ApplicationController
	def index
	end

	def testscript
		require "net/http"
		require "json"
		require "rubygems"

# courseName = ARGV[0]
# courseURL = ARGV[1]

courseName = "CS106B"
courseURL = "http://web.stanford.edu/class/cs106b/"

course = Course.new(name: courseName)
course.save
diffbotURLToken = ""
api = ""

case courseName
when courseName = "CS106B"
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
when courseName = "PWR1"
	api = "PWR"
else
	api = "CS103"
end	


diffBotParameter = "/api/" + api + "?token=73659789c3c2aa6d84fd9812b5ba57dc&url=" + courseURL


response = Net::HTTP.get_response("diffbot.com", diffBotParameter)
json = JSON.parse(response.body)

k = 0
json["AnnouncementBody"]. each do |sivayetski|
	curHeader = json["AnnouncementHeader"][k]["Header"]
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

	update = Update.new(title: curHeader, date: curDate, body: curDescription, isHW: hw, isExam: exam, isPiazza: false)
	update.course = course
	update.save
	k = k + 1 
end


@courses = Course.all
end




def post_course
	hex = 0
	case params[:courseColor]
	when "red"
		hex = "#FFD2D2"
	when "orange"
		hex = "#FFE9D7"
	when "yellow"
		hex = "#FFFDC0"
	when "green"
		hex = "#E9FFD4"
	when "teal"
		hex = "#C0FFEA"
	when "blue"
		hex = "#C2EFFF"
	when "purple"
		hex = "#DAD9FF"
	else
		hex = "#F8C7FF"
	end
	#check if course was already created
	course = 0
	if !Course.exists?(:name => params[:courseName])
		course = Course.new(name: params[:courseName], syllabusLink: params[:courseID], color: hex)
	else
		course = Course.find_by_name(params[:courseName])
	end

	course.save
	Update.reimageUpdatesForCourse(course.id)
	puts "updated course #{course.id}"
	render :nothing => true
end




def loadPiazzaData
	# filePath = Dir.pwd
	filePath = Rails.root.to_s + "/app/scripts"
	folderPath = filePath + "/CS\ 103"
	Dir.chdir folderPath
	dirStruct = Dir.new Dir.pwd

	course = 0
	if !Course.exists?(:name => "CS 103")
		course = Course.new(name: "CS 103", color: "#C2EFFF")
		course.save
	else
		course = Course.find_by_name("CS 103")
	end



	count = Dir["**/*"].length
	count = (count/3) - 1

	(1..count).each do |i|
		puts "VALUE OF I: #{i}"
		titleName = "title" + i.to_s + ".txt"
		dateName = "date" + i.to_s + ".txt"
		bodyName = "body" + i.to_s + ".txt"

		title = File.read(titleName)
		date = File.read(dateName)
		body = File.read(bodyName)

		hw = false
		exam = false

		if body.match(/midterm/i)
			exam = true
		end
		if body.match(/final/i)
			exam = true
		end 
		if body.match(/exam/i)
			exam = true
		end
		if body.match(/test/i)
			exam = true
		end

		if body.match(/hw/i)
			hw = true
		end
		if body.match(/assignment/i)
			hw = true
		end 
		if body.match(/problem/i)
			hw = true
		end
		if body.match(/homework/i)
			hw = true
		end



		update = Update.new(title: title, date: Date.parse(date[0..9]), body: body, isHW: hw, isExam: exam, isPiazza: true)
		update.course = course;
		update.save
	end


	folderPath = filePath + "/CS\ 110"
	Dir.chdir folderPath
	dirStruct = Dir.new Dir.pwd

	if !Course.exists?(:name => "CS 110")
		course = Course.new(name: "CS 110", color: "#FFD2D2")
		course.save
	else
		course = Course.find_by_name("CS 110")
	end
	count = Dir["**/*"].length
	count = (count/3) - 1

	(1..count).each do |i|
		titleName = "title" + i.to_s + ".txt"
		dateName = "date" + i.to_s + ".txt"
		bodyName = "body" + i.to_s + ".txt"

		title = File.read(titleName)
		date = File.read(dateName)
		body = File.read(bodyName)

		hw = false
		exam = false

		if body.match(/midterm/i)
			exam = true
		end
		if body.match(/final/i)
			exam = true
		end 
		if body.match(/exam/i)
			exam = true
		end
		if body.match(/test/i)
			exam = true
		end

		if body.match(/hw/i)
			hw = true
		end
		if body.match(/assignment/i)
			hw = true
		end 
		if body.match(/problem/i)
			hw = true
		end
		if body.match(/homework/i)
			hw = true
		end

		update = Update.new(title: title, date: Date.parse(date[0..9]), body: body, isHW: hw, isExam: exam, isPiazza: true)
		update.course = course;
		update.save
	end

	redirect_to(:controller => :announcements, :action => :index)

end


end
