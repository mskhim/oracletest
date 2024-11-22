
--subject 테이블 작성 (학과)
create table subject( 
    no number,                          --시퀀스로 작성 pk
    num varchar2(2) not null,           --학과 번호 01,02,03,04 uk
    name varchar2(24) not null
);
(select nvl(max(no),0)+1 from subject); -------------no를 정해주는 쿼리
alter table subject add constraint SUBJECT_NO_PK primary key(no);
alter table subject add constraint SUBJECT_NUM_UQ UNIQUE(num);

create table student( 
no number ,                         --pk 
num varchar2(8) not null,           --학번(연도 학과 번호 00/00/0000) uk
name varchar2(12) not null,         --이름
id varchar2(12) not null,           --아이디 uk
pwd varchar2(12) not null,          --비밀번호
SUBJECT_num varchar2(2) not null,   --학과번호 fk
birthday varchar2(8) not null,      --생년월일
phone varchar2(15) not null,        --핸드폰번호
address varchar2(80) not null,      --주소
email varchar2(40) not null,        --이메일
sdate date default sysdate          --등록일자
);
(select nvl(max(no),0)+1 from student);--------no를 정해주는 쿼리
alter table student add constraint STUDENT_NO_PK primary key(no);
alter table student add constraint STUDENT_NUM_UQ UNIQUE(num);
alter table student add constraint STUDENT_ID_UQ UNIQUE(ID);
alter table student add constraint STUDENT_SUBJECT_NUM_FK FOREIGN KEY(SUBJECT_NUM) REFERENCES SUBJECT(num) on delete set null;

create table lesson(                  --과목
    no number,                        --pk 
    abbre varchar2(2) not null,       --강의명 uq 
    name varchar2(20) not null        --과목 이름
    );

    alter table lesson add constraint LESSON_NO_PK primary key(no);
    alter table lesson add constraint STUDENT_ABBRE_UQ UNIQUE(abbre);

create table trainee( 
    no number ,                              --pk seq
    STUDENT_num varchar2(8) not null,        --학생번호 fk(STUDENT)
    LESSON_abbre varchar2(2) not null,       --강의명 fk(LESSON)
    section varchar2(20) not null,           --전공, 부전공, 교양
    tdate date default sysdate               --입력 날짜
);
    alter table trainee add constraint TRAINEE_NO_PK primary key(no);
    alter table trainee add constraint TRAINEE_STUDENT_NUM_FK FOREIGN KEY(STUDENT_num) REFERENCES STUDENT(num) on delete set null;
    alter table trainee add constraint TRAINEE_LESSON_ABBRE_FK FOREIGN KEY(LESSON_abbre) REFERENCES LESSON(abbre) on delete set null;

