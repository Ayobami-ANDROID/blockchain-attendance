//SPDX-Licensce-Identifier: MIT
pragma solidity ^0.8.8;

contract attendance{
struct student{
    string firstname;
    string lastname;
    string matricNo;
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

// struct attendance{
//     course courseAttendance;
//     attendStatus [] attended; 
// }

Course[] public courseList;
student[] public StudentList;

mapping(address => student) address_to_student;
mapping(address => lecturer) LecturerList;
mapping(uint => Course) CourseNumber;
uint no;
uint totalNumberOfCourse;


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


function registerStudent(string memory firstName, string memory lastName, string memory matricNo, uint regno, uint level ) public{
    require(bytes(firstName).length > 0,"firstname cannot be empty");
    require(bytes(lastName).length > 0,"lastname cannot be empty");
    require(bytes(matricNo).length > 0,"lastname cannot be empty");
    student storage newStudent = address_to_student[msg.sender];
    newStudent.firstname = firstName;
    newStudent.lastname = lastName;
    newStudent.matricNo = matricNo;
    newStudent.regNo = regno;
    newStudent.level = level;
    StudentList.push(newStudent);
    no++;
}

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


}