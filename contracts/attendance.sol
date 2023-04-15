//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract attendance{

//to register student
struct student{
    string firstname;
    string lastname;
    string matricNo;
    string department;
    College colleges;
    uint regNo;
    uint level;
    address addr;
    Course[] courselist;
}

//to register course
struct Course{
    string courseTitle;
    string courseCode;
    string lecturerName;
    uint totalAttendance;
    uint[] timeStamp;
    AttendStatus[] attended;
}

//to register lecturer
struct lecturer{
    string name;
    Course[] courseTitle;
}

//attendance status
enum AttendStatus{
    present,
    absent
}

//college
enum College{
    cpas,
    cbs,
    coe,
    cas
}

// struct attendance{
//     course courseAttendance;
//     attendStatus [] attended; 
// }

Course[] public courseList; //array of courses
student[] public StudentList;//array of students
lecturer[] public lecturerList;//array of lecturer

mapping(address => student) address_to_student;//mapping of address to student
mapping(address => lecturer) address_to_lecturer;// mapping of address to lecturer
mapping(uint => Course) CourseNumber;// mapping of int to course
uint no;
uint totalNumberOfCourse;

//to create new course
function createCourse(string memory title,string memory code,string memory name) public {
    require(bytes(title).length > 0, "course title cannot be used");
    require(bytes(code).length > 0, "course code cannot be used");
    require(bytes(name).length > 0, "Lecturer name cannot be empty");
    Course storage newCourse = CourseNumber[no];
    newCourse.courseTitle = title;
    newCourse.courseCode = code;
    // newCourse.lecturerName = name;
    newCourse.totalAttendance = 0;
    totalNumberOfCourse ++;
    no++;
}

//to register student
function registerStudent(string memory firstName, string memory lastName, string memory matricNo, string memory dept, uint regno, uint level,College col ) public{
    require(bytes(firstName).length > 0,"firstname cannot be empty");
    require(bytes(lastName).length > 0,"lastname cannot be empty");
    require(bytes(matricNo).length > 0,"lastname cannot be empty");
    student storage newStudent = address_to_student[msg.sender];
    newStudent.firstname = firstName;
    newStudent.lastname = lastName;
    newStudent.matricNo = matricNo;
    newStudent.regNo = regno;
    newStudent.level = level;
    newStudent.department = dept;
    newStudent.colleges = col;
    newStudent.addr = msg.sender;
    StudentList.push(newStudent);
}

//to return all the list of courses available
function getAllCourses() public view returns(Course[] memory){
    return courseList;
}

//to return all the student
function getAllStudent() public view returns(student[] memory){
    return StudentList;
} 

//validateCourse
function validateCourse(uint n) public view returns(bool) {
    string memory courseCode = CourseNumber[n].courseCode;
    for (uint i = 0; i < address_to_student[msg.sender].courselist.length; i++) {
        if (keccak256(bytes(address_to_student[msg.sender].courselist[i].courseCode)) == keccak256(bytes(courseCode))) {
            return true;
        }
    }
    return false;
}

//to add a course
function addCourse(uint n) public{
    require(n <= no,"this course does not exist");
    require(validateCourse(n) == false,"you have already registered course");
    Course storage courseAdded = CourseNumber[n];
    address_to_student[msg.sender].courselist.push(courseAdded);
}

//get student course
function getStudentCourse() public view returns(Course[] memory){
   Course[] storage studentCourses = address_to_student[msg.sender].courselist; 
   return studentCourses;
}

//to delete a course
function deleteCourse(uint index) public  returns(Course[] memory)  {
    student storage myStudent = address_to_student[msg.sender];
    require(index < myStudent.courselist.length, "Index out of bounds");

    for (uint i = index; i < myStudent.courselist.length - 1; i++) {
        myStudent.courselist[i] = myStudent.courselist[i+1];
    }

    delete myStudent.courselist[myStudent.courselist.length - 1];
    myStudent.courselist.pop();
    return myStudent.courselist;

}

//create a lecturer
function createLecturer(string memory name,address lectures) public{
    lecturer storage newLecturer = address_to_lecturer[lectures];
    newLecturer.name = name;
    
}

//to add a lecturer course
function AddlecturerCourse(uint course,address lectures) public{
    lecturer storage addCourseLecturer = address_to_lecturer[lectures];
    addCourseLecturer.courseTitle.push(CourseNumber[course]); 
} 

//to add get a list of courses taken by a lecturer
function lecturerCourseList (address lecture) public view returns(Course [] memory){
    Course[] storage lecturer_course = address_to_lecturer[lecture].courseTitle;
    return lecturer_course; 
}

function takeAttendance(uint n,address t,uint index,uint[] memory reg,AttendStatus status) public{
    require(n <= no,"this course does not exist");
    require(index <= address_to_lecturer[t].courseTitle.length,"you don't lecture this course" );
    address_to_lecturer[t].courseTitle[index].totalAttendance +=1;
    
    for(uint i =0; i< reg.length;i++){
        if(reg[i] == StudentList[i].regNo){
            address addr = StudentList[i].addr;
            for(uint x=0; x< courseList.length;i++){
                require(keccak256(bytes(address_to_student[addr].courselist[x].courseCode)) == keccak256 (bytes(CourseNumber[no].courseCode)),"course not found");
                address_to_student[addr].courselist[x].attended.push(status);
            }
            
        }
    }

}
    

}