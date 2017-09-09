user1 = User.create(username: "TylerB", password: "1234", email: "tb@somesuch", goal: "become a fullstack dev")
user2 = User.create(username: "JonS", password: "ghost", email: "js@thewall", goal: "know something")
user3 = User.create(username: "HarryP", password: "alohomora", email: "hp@hogwarts", goal: "magic stuff")

platform1 = Platform.new(name: "Flatiron School", description: "Coding Bootcamp")
platform2 = Platform.new(name: "Udacity", description: "MOOCs and nanodegrees")
platform3 = Platform.new(name: "Coursera", description: "MOOCs through top universities")

program1 = platform1.programs.build(name: "Fullstack Web Development with React",
                          description: "Learn full stack web development in Ruby and Javascript", cost: 6000)
program2 = platform2.programs.build(name: "Java Programming and Software Engineering Fundamentals", certification: "specialization",
                          description: "Learn the basics of programming and software development", cost: 300, affiliation: "Duke")
program3 = platform2.programs.build(name: "Python For Everybody", certification: "specialization",
                          description: "Learn to Program and Analyze Data with Python.", cost: 300, affiliation: "Michigan")
program4 = platform3.programs.build(name: "Android Developer Nanodegree", certification: "nanodegree", affiliation: "Google",
                          description: "Learn full stack web development in Ruby and Javascript", cost: 6000)
Program.create(name: "Individual Courses")

course1 = program1.courses.build(name: "Ruby", description: "An intro to Ruby", length_in_hours: 150, creator_id: user1.id)
course2 = program1.courses.build(name: "Sinatra", description: "Sinatra, SQL, ActiveRecord", length_in_hours: 150, creator_id: user1.id)
course3 = program1.courses.build(name: "Rails", description: "Put it all together in Ruby on Rails", length_in_hours: 150, creator_id: user1.id)
course4 = program1.courses.build(name: "Rails and JavaScript", description: "Learn JS to take the next step", length_in_hours: 150, creator_id: user1.id)
course5 = program1.courses.build(name: "React and Redux", description: "Full Stack JS Development", length_in_hours: 150, creator_id: user1.id)
course6 = program2.courses.build(name: "Principles of Software Design", description: "Java OO and beyond", length_in_hours: 50, creator_id: user1.id)
course7 = program2.courses.build(name: "Solving Problems with Software", description: "Intro to Java", length_in_hours: 40, creator_id: user1.id)
course8 = program2.courses.build(name: "Arrays, Lists, and Structured Data", description: "Java data structures", length_in_hours: 40, creator_id: user1.id)
course9 = program3.courses.build(name: "Programming for Everybody", description: "Python 101", length_in_hours: 20, creator_id: user1.id)
course10 = program3.courses.build(name: "Python Data Structures", description: "Lists, dictionaries and more", length_in_hours: 30, creator_id: user1.id)
course11 = program3.courses.build(name: "Using Databases with Python", description: "Using SQL with Python", length_in_hours: 30, creator_id: user1.id)
course12 = program4.courses.build(name: "Developing Android Apps", description: "Learn to build apps", length_in_hours: 80, creator_id: user1.id)
course13 = program4.courses.build(name: "Advanced Android Development", description: "Add responsiveness to your apps", length_in_hours: 80, creator_id: user1.id)
course14 = program4.courses.build(name: "Gradle For Android and Java", description: "Learn Gradle Builds", length_in_hours: 80, creator_id: user1.id)

platform1.save
platform2.save
platform3.save

subject1 = Subject.new(name: "Computer Science")
subject2 = Subject.new(name: "Web Development")
subject3 = Subject.new(name: "Ruby")
subject4 = Subject.new(name: "JavaScript")
subject5 = Subject.new(name: "Python")
subject6 = Subject.new(name: "Java")
subject7 = Subject.new(name: "Android")
subject8 = Subject.new(name: "SQL")

Course.all.each {|c| c.subjects << subject1}
platform1.courses.each {|c| c.subjects << subject2}
course1.subjects << subject3
course2.subjects << subject3
course3.subjects << subject3
course4.subjects << subject3
course4.subjects << subject4
course5.subjects << subject4
program3.courses.each {|c| c.subjects << subject5}
program2.courses.each {|c| c.subjects << subject6}
program4.courses.each {|c| c.subjects << subject6}
program4.courses.each {|c| c.subjects << subject7}
course2.subjects << subject8
course11.subjects << subject8

program1.courses.each {|c| user1.courses << c}
program2.courses.each {|c| user1.courses << c}
program3.courses.each {|c| user1.courses << c}
program4.courses.each {|c| user1.courses << c}
program1.courses.each {|c| user2.courses << c}
program3.courses.each {|c| user2.courses << c}
program1.courses.each {|c| user3.courses << c}
program2.courses.each {|c| user3.courses << c}
program4.courses.each {|c| user3.courses << c}

user1.save
user2.save
user3.save

platform1.save
platform2.save
platform3.save
