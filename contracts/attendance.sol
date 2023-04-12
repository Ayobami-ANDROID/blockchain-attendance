//SPDX-Licensce-Identifier: MIT
pragma solidity ^0.8.8;

contract attendance{
struct student{
    string firstname;
    string lastname;
    string matricNo;
    string department;
    College colleges;
    uint regNo;
    uint level;
    Course[] courseList;
}

struct Course{
    string courseTitle;
    string courseCode;
    string lecturerName;
    uint totalAttendance;
    AttendStatus[] attended;
}

struct lecturer{
    string name;
    Course[] courseTitle;
}

enum AttendStatus{
    present,
    absent
}

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

Course[] public courseList;
student[] public StudentList;
lecturer[] public lecturerList;

mapping(address => student) address_to_student;
mapping(address => lecturer) address_to_lecturer;
mapping(uint => Course) CourseNumber;
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
    newCourse.lecturerName = name;
    newCourse.totalAttendance = 0;
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
    StudentList.push(newStudent);
    no++;
}

//to return all the list of courses available
function getAllCourses() public view returns(Course[] memory){
    return courseList;
}

function getAllStudent() public view returns(student[] memory){
    return StudentList;
} 

function addCourse(uint n) public{
    require(n <= no,"this course does not exist");
    Course storage courseAdded = CourseNumber[n];
    address_to_student[msg.sender].courseList.push(courseAdded);
}

function deleteCourse(uint index) public  returns(Course[] memory)  {
    student storage myStudent = address_to_student[msg.sender];
    require(index < myStudent.courseList.length, "Index out of bounds");

    for (uint i = index; i < myStudent.courseList.length - 1; i++) {
        myStudent.courseList[i] = myStudent.courseList[i+1];
    }

    delete myStudent.courseList[myStudent.courseList.length - 1];
    myStudent.courseList.pop();
    return myStudent.courseList;

}

function createLecturer(string memory name) public{}
    

}