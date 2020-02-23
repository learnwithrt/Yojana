-- CREATE DATABASE IF NOT EXISTS ProjectYojana;
-- ##DROP DATABASE ProjectYojana;
-- USE ProjectYojana;
##Drop table User;
CREATE TABLE User(
	User_ID CHAR(12) PRIMARY KEY,
	User_Gender CHAR(1) NOT NULL CHECK(User_Gender='F'or User_Gender='M' or User_Gender='X') ,
	User_Name text(40) NOT NULL,
	User_email text(255) not null,
    User_photo mediumblob not null,##Since blob can store only 65Kilo bytes of data, mediumblob can store 16,777,215 bytes.
	User_Password text(255) not null
);
##select * from User;
##Drop table Department
CREATE TABLE Department(
	Dep_ID INT AUTO_INCREMENT PRIMARY KEY,
	Dep_Name text(40) NOT NULL,
    Dep_Head text(12) NOT NULL references User(User_ID)
)AUTO_INCREMENT=110;

##Drop table Project
CREATE TABLE Project(
	Project_ID INT AUTO_INCREMENT PRIMARY KEY,
	Project_Name text(40) NOT NULL,
    Project_Description text(255) NOT NULL,
    Project_Duration int NOT NULL,
    Project_Manager text(12) NOT NULL references User(User_ID),
	Project_photo mediumblob 
)AUTO_INCREMENT=202000;
##drop table task;
CREATE TABLE Task(
	T_ID INT AUTO_INCREMENT PRIMARY KEY,
    T_Name Text(255) not null,
	Project_ID CHAR(12) references Project(Project_ID),
    T_start_date datetime NOT NULL,
    T_end_date datetime NOT NULL,
    T_description text(255) not null,
    T_assigned_to CHAR(12) references User(User_ID),
    T_Parent INT references Task(T_ID)
);
DELIMITER //
CREATE PROCEDURE GetUserInfo(
IN username char(12))
BEGIN
	SELECT * FROM User where User_ID=username;
END//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE GetTaskInfo(
IN username char(12))
BEGIN
	SELECT * FROM Task where Task_ID=id;
END//
DELIMITER ;
##drop procedure GetProjectInfo;
DELIMITER //
CREATE PROCEDURE GetProjectInfo(
IN id char(12))
BEGIN
	SELECT * FROM Project where Project_ID=id;
END//
DELIMITER ;
##drop procedure Reg_User;
DELIMITER //
CREATE PROCEDURE Reg_User(
IN username char(12), 
IN gender char(1),
IN name text(25),
IN email text(255),
IN photo text(255),
IN pass text(255))
BEGIN
	IF(photo IS NULL)THEN
		SET photo='N/A';
 	END IF;
	INSERT INTO User(User_ID, User_Gender,User_Name,User_email,User_photo,User_Password) VALUES(username,gender,name,email,photo,md5(pass));
END//
DELIMITER ;
##drop Procedure Login_User;
DELIMITER //
CREATE PROCEDURE Login_User(IN username CHAR(12), IN pass text(255))
BEGIN
	DECLARE password text(18);
	SELECT User_Password INTO password  FROM User WHERE User_ID = username;
	select if(STRCMP(pass,password)= 0,1,0) as str_compare;
END//
DELIMITER ;
##DROP PROCEDURE New_Project;
DELIMITER //
CREATE PROCEDURE New_Project(IN ID INT,
	IN name text(255),
	IN description text(255),
	IN duration int ,
    IN department int,
	IN manager text ,
	IN photo text(255))
BEGIN
	IF(photo IS NULL)THEN
		SET photo='N/A';
	END IF;
	INSERT INTO Project(Project_ID, Project_Name,Project_Description,Project_Duration,Project_department,Project_Manager,Project_Photo) 
    VALUES(ID, name, description, duration,department, manager, photo);
END//
DELIMITER ;

##drop procedure Update_Project;
DELIMITER //
CREATE PROCEDURE Update_Project(IN ID INT,
	IN name text(255),
	IN description text(255),
	IN duration int ,
    IN department int,
	IN manager text ,
	IN photo text(255))
BEGIN
	IF(photo IS NULL)THEN
		SET photo='N/A';
	END IF;
	Update Project set Project_Name=name,Project_Description=description,
    Project_Duration=duration,Project_department=department,Project_Manager=manager,Project_Photo=photo where Project_ID=ID;
END//
DELIMITER ;


##Drop procedure Delete_Project;
DELIMITER //
CREATE PROCEDURE Delete_Project(IN Project_ID TEXT(25))
BEGIN
	START TRANSACTION;
    ##Delete the Project Details
    DELETE FROM Project WHERE Project_ID = @Project_ID;
    ##Also delete the tasks created for this project
	Delete From Task where Project_ID = @Project_ID;
	COMMIT;
END//
DELIMITER ;
##Drop procedure New_Task;
DELIMITER //
CREATE PROCEDURE New_Task(IN ID INT,
	IN name text(255),
	IN Project_ID INT,
	IN start_date datetime,
    IN end_date datetime,
	IN description text(255) ,
	IN asignee CHAR(12),
    IN parent INT)
BEGIN
	IF(parent IS NULL)THEN
		SET parent=-1;##-1 indicates that it's a primary task, not a sub task
	END IF;
	INSERT INTO Task(T_ID, T_Name,Project_ID,T_start_date,T_end_date,T_description,T_assigned_to,T_Parent) 
    VALUES(ID, name, @Project_ID, start_date,end_date, description, asignee,parent);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Update_Task(IN ID INT,
	IN name text(255),
	IN Project_ID INT,
	IN start_date datetime,
    IN end_date datetime,
	IN description text(255) ,
	IN asignee CHAR(12),
    IN parent INT)
BEGIN
	IF(parent IS NULL)THEN
		SET parent=-1;
	END IF;
	Update Task set T_Name=name,T_Description=description,
    Project_ID=@Project_ID,T_start_date=start_date,T_end_date=end_date,T_assigned_to=asignee,T_parent=parent where T_ID=ID;
END//
DELIMITER ;

##Drop procedure Delete_Task;
	DELIMITER //
	CREATE PROCEDURE Delete_Task(IN Task_ID TEXT(25))
	BEGIN
		START TRANSACTION;
		##Delete the Task Details
		DELETE FROM Task WHERE Task_ID = @Task_ID;
		COMMIT;
	END//
	DELIMITER ;

-- CALL Reg_User('User1001', 'M','Rahul','rahuldtalreja@gmail.com','N/A','admin');
-- CALL Reg_User('User1002', 'F','Angel','angellica@gmail.com',null,'angel');
-- Call Login_User('User1001','admins');
-- select * from Project;
-- select * from Task;
-- delete from User;
-- select * from User;
-- select * from Project;