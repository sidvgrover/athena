from piazza_api import Piazza
from pprint import pprint
import os
import json
import string
from HTMLParser import HTMLParser


class MLStripper(HTMLParser):
    def __init__(self):
        self.reset()
        self.fed = []
    def handle_data(self, d):
        self.fed.append(d)
    def get_data(self):
        return ''.join(self.fed)

def strip_tags(html):
    s = MLStripper()
    s.feed(html)
    return s.get_data()

p = Piazza()
p.user_login('thomklau@stanford.edu', 'thomaslau')

f = open('userProfile.txt','w')
json.dump(p.get_user_profile(), f)
f.close()

rawUserData = open('userProfile.txt')
jsonUserData = json.load(rawUserData)
rawUserData.close()


masterPath = os.getcwd()

for i in jsonUserData["all_classes"]:
    classConnection = p.network(i)
    posts = classConnection.iter_all_posts(limit=100000)

    className = jsonUserData["all_classes"][i]["num"]
    if className == "CS 103":
        x = 0
    elif className == "CS 110":
        x = 0
    else:
        continue


    # reset to the relative root
    os.chdir(masterPath)
    if not os.path.exists(masterPath + "/" + className):
        os.mkdir(masterPath + "/" + className)
    os.chdir(masterPath + "/" + className)

    postCount = 0
    for post in posts:
        tags = post["tags"]
        if "instructor-note" not in tags:
            continue

        postCount = postCount + 1
        titleName = "title" + str(postCount) + ".txt"
        dateName = "date" + str(postCount) + ".txt"
        bodyName = "body" + str(postCount) + ".txt"


        text = post["history"][0]["content"]
        title = post["history"][0]["subject"]
        date = post["history"][0]["created"]

        text = filter(lambda x: x in string.printable, text)
        text = strip_tags(text)

        title = filter(lambda x: x in string.printable, title)
        title = strip_tags(title)

        date = filter(lambda x: x in string.printable, date)
        date = strip_tags(date)

        curPostFileStream = open(titleName, 'w')
        curPostFileStream.write(title)
        curPostFileStream.close()   

        curPostFileStream = open(dateName, 'w')
        curPostFileStream.write(date)
        curPostFileStream.close()

        curPostFileStream = open(bodyName, 'w')
        curPostFileStream.write(text)
        curPostFileStream.close()