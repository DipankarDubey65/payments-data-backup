SET SQL_SAFE_UPDATES = 0;

-- ---------UPDATE PROCEDURE----------------
delimiter //
create procedure update_amount(in checkno varchar(10), in amt float)
begin
update payments set amount =  amt where checkNumber = checkno;
end//
delimiter ;

 # UPDATA BACKUP DATA:
 
create table backupdata(customerNumber int, checkNumber int, 
paymentDate date, amount decimal(10,2), update_date timestamp default now(),
    primary key(customerNumber,checkNumber)
);


alter table backupdata modify checkNumber varchar(50); 
select * from backupdata;
delimiter //
create trigger update_triggers after update on payments
for each row
begin
 insert into backupdata(customerNumber,checkNumber,paymentDate,amount)
 values(old.customerNumber,old.checkNumber,old.paymentDate,old.amount);
end//
delimiter ;


-- --------------DELETE PROCEDURE -------------------

# stored procedure
delimiter //
create procedure delete_data(in check_no varchar(50))
begin 
 delete from payments where checkNumber = check_no;
end//
delimiter ;


 # delete data of backup
create table delete_backup(
id int primary key auto_increment,customerNumber int, checkNumber varchar(50), paymentDate date, amount decimal(10,2),
delete_time timestamp default now()
);

# Trigeer
delimiter //
create trigger dt_data before delete on payments
for each row
begin
 insert into  delete_backup(customerNumber,checkNumber,paymentDate,amount)
 values(old.customerNumber,old.checkNumber,old.paymentDate,old.amount);
end
//
 delimiter ;
 
-- ------------INSERT DATA -----------------
 # store procedure
 
 delimiter //
 create procedure insert_data(in customerNumber int , in checkNumber varchar(50),in paymentDate date, in amount decimal(10,2))
 begin
  insert into payments values(customerNumber,checkNumber,paymentDate,amount);
 end //
 delimiter ;
 
 -- insert data backup
 create table new_data(
 id int primary key auto_increment,
 customerNumber int,
 checkNumber varchar(50),
 amount decimal(10,2),
 paymentDate timestamp default now()
 );
 
 delimiter //
 create trigger ins_data after insert on payments
 for each row
 begin
 insert into new_data(customerNumber,checkNumber,amount) values(new.customerNumber,new.checkNumber,new.amount);
 end//
 delimiter ;
 
 
 
 
-- update amount by using check number in payments table
call update_amount('HQ336336',11000);
select * from backupdata;

-- delete data from payments table through check.
call delete_data('HQ336336');
select *from delete_backup;

-- insert data
call insert_data(103,'HQ336336','2025-01-29',11000.00);

select * from new_data;



