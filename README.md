![athena](http://i57.tinypic.com/200prb7.png)

Built with Thomas Lau, Stuart Sy, and Jamie Korman

#Motivation
College course materials are heavily decentralized. Courses often have their own websites independent of a unified platform, and instructors post course updates in a variety of locations - sometimes on the websites, and sometimes on a forum called Piazza.

Our project, athena, seeks to provide a centralized platform on which a student can get all of the updates for their courses without having to visit several different websites.

#Methodology
To enroll in a class, a user merely needs to type in its name and a course URL. We use a bleeding edge computer vision api, diffbot, to parse the website's data and extract the announcements into a single feed. We also use the piazza api to rip instructor posts from the classes associated with a user's piazza account and merge them with those extracted from the website.

Finally, we apply natural language processing algorithms to tag the posts if they concern homework or exams. Students can filter their news feed to limit posts to certain courses or tags.