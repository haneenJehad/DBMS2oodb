--campus
create or replace campus_t  as object();
--professor: 
CREATE OR REPLACE TYPE Professor_T AS object
(prof_ID VARCHAR2(10),
 prof_name VARCHAR2(20),
 prof_contact VARCHAR2(12),
 prof_research VARCHAR2(12),
 prof_year NUMBER)
);
CREATE OR REPLACE TYPE Professors AS VARRAY(5) OF
Professor_T;

--units: varray 5 varchar2

--school
CREATE OR REPLACE TYPE School_T AS object
(school_id VARCHAR2(12),
 school_name VARCHAR2(20),
 school_head VARCHAR2(20),
 school_prof Professors)
);
CREATE OR REPLACE TYPE School_Table_T AS TABLE OF
School_T;

--department
CREATE OR REPLACE TYPE Department_T AS object
(dept_id VARCHAR2(12),
 dept_name VARCHAR2(20),
 dept_head VARCHAR2(20),
 dept_prof Professors)
);
CREATE OR REPLACE TYPE Department_Table_T AS TABLE OF
Department_T;

--research-center

--faculty

--equipments: varray 3 varchar2 

--building

--office 

--classroom

--lab

--degree

CREATE OR REPLACE TYPE Degree_T AS OBJECT(
  deg_ID VARCHAR2(20),
  deg_name VARCHAR2(30),
  deg_length VARCHAR2(30),
  deg_prereq VARCHAR2(30),
  faculty REF Faculty_T,
  
  STATIC PROCEDURE insert_degree (
    dge_id IN VARCHAR,
    deg_name IN VARCHAR2,
    deg_length IN VARCHAR2,
    deg_prereq IN VARCHAR2,
    fact_id IN VARCHAR2
  ),
  MEMBER PROCEDURE delete_degree,
  MEMBER PROCEDURE show_deg_record
);


CREATE TABLE Degrees OF Degree_T(
  PRIMARY KEY(deg_ID)
);

CREATE TABLE Degree_Records (
  deg_id VARCHAR2(20) PRIMARY KEY,
  deg_name VARCHAR2(30),
  deg_length  VARCHAR2(30),
  deg_prereq  VARCHAR2(30),
  all_students INTEGER
  
);

CREATE TYPE BODY Degree_T AS 
    STATIC PROCEDURE insert_degree (
    dge_id IN VARCHAR,
    deg_name IN VARCHAR2,
    deg_length IN VARCHAR2,
    deg_prereq IN VARCHAR2,
    fact_id IN VARCHAR2
  ) IS
     faculty REF Faculty_T;
    Begin
      SELECT REF(f) INTO faculty FROM Faculty f
      WHERE f.fact_id = fact_id;
      
      INSERT INTO Degrees VALUES
      (dge_id , deg_name , deg_length , deg_prereq , faculty);
    END insert_degree;
    
    MEMBER PROCEDURE delete_degree IS
      BEGIN 
        DELETE FROM Enrolls_In WHERE Enrolls_In.degree 
        IN (SELECT REF(d) FROM Degrees d 
        WHERE d.deg_id = SELF.deg_id);
        
        DELETE FROM Degrees d 
        WHERE d.deg_id = SELF.deg_id;
      END delete_degree;
        
    MEMBER PROCEDURE show_deg_record IS
      all_degrees INTEGER;
       BEGIN 
        SELECT COUNT(*) AS All_Students INTO 
        all_degrees FROM Degrees d , Enrolls_In e
        WHERE e.degree = REF(d) AND d.deg_id = SELF.deg_id GROUP BY d.deg_id;
   
        INSERT INTO Degree_Records VALUES 
        (SELF.deg_id , SELF.deg_name
         , SELF.deg_length , SELF.deg_prereq , all_degrees );
  
    END show_deg_record;
END;

--person

--staff

--student

--admin

--technician

--lecturer

--senior_lecturer

--associate_lecturer

--tutor

--enrolls_in

--BODY OF OFFICE -SONDOS

--subject

--takes



