-- �H�U�O���u��� :
-- id			first name			last name		salary			birthday
-- 100		�p��						��				30000.5		2000-01-01
-- 200		����						��				40000.8		1998-02-01
-- 300		�j��						�i				45000.9		1995-03-01
-- 400		�p��						��				35000.1		2002-05-01

--  �нm�߼��g�H�U"���O", �Ш��D�N�^��


--  1.  �Ф����� LabDB ��Ʈw�U, �P�� drop ��, �p�G�w�s�b�� table  employee 

use LabDB
go

drop table if exists employee

--  2.  �Х��إߤ@employee ��ƪ�ȥ]�t �U�C�|�����, id �O primary key  (��� birthday �����n�إ�)
--       id			first name			last name		salary

create table employee(
id int primary key(id),
[first name] nvarchar(20),
[last name] nvarchar(20),
salary decimal(10, 1)
)

-- 3.  �Х��λy�k�s�W���u�򥻸��     id			first name			last name		salary

insert employee values (100,'�p��','��',30000.5)
insert employee values (200,'����','��',40000.8)
insert employee values (300,'�j��','�i',45000.9)
insert employee values (400,'�p��','��',35000.1)

--  4.  �d�ߤ@�U�Ҧ����u���

select * from employee

--  5.  �d�ߤ@�U�~���j��40000 �Ҧ����u���, �å��~���� �Ѥj��p�Ƨ�

select *
from employee
where salary>40000
order by salary desc


--  6.  �N��ƪ� employee �W�[�@"�ͤ����", 
--  �դ@�ձN"�ͤ����"�]�� not null �M null ���t�O, ���G���P������?

alter table employee
 add birthday date

--  7.  �@���u�s�� �ק�/�W�[  �ͤ���

update employee set birthday = '2000-01-01' where id = 100
update employee set birthday = '1998-02-01' where id = 200
update employee set birthday = '1995-03-01' where id = 300
update employee set birthday = '2002-05-01' where id = 400

-- 8.  �p��@�U�Ҧ����u�~���`�M

select sum(salary) as ���u�~���`�M
from employee


-- 9.  �p��@�U���u�ӧO���~��(�~��~�Y�i)

select
id,
[first name],
[last name],
year(GETDATE())-YEAR(birthday) as �~��
from employee

-- 10. �ЦC�L�X�~��̤֭��u���Ҧ����

select top(1) *
from employee
order by salary

-- 11.  �ЧR�� ���p�� �H�Ƹ��

delete employee where id = 100


-- ú��@�~�бH��@�U�H�c :
-- Email : jungan0914@gmail.com
