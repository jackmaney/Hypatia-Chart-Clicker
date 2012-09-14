create hypatia_test_xy (x1 int, x2 float, y1 float,y2 float);
insert into hypatia_test_xy values(1,1.1,7.22,2.1);
insert into hypatia_test_xy values(2,-2.1,3.88,-0.5);
insert into hypatia_test_xy values(4,3.3,6.2182,3);
insert into hypatia_test_xy values(6,0,2.71828,3.1415926);
insert into hypatia_test_xy values(5,7,4.1,1.41);

create table hypatia_test_bubble (a float, b float, c float);
insert into hypatia_test_bubble values (0,3,1.1);
insert into hypatia_test_bubble values (0.9,4,0.5);
insert into hypatia_test_bubble values (2,6.1,2.2);
insert into hypatia_test_bubble values (6,4.4,1.9);

create table hypatia_test_bubble_multi1 (x1 float, y1 float, size1 float, x2 float, y2 float, size2 float);
insert into hypatia_test_bubble_multi1 values (3,2,0.4,5,1,0.8);
insert into hypatia_test_bubble_multi1 values (1,6,1,4,7,1.3);
insert into hypatia_test_bubble_multi1 values (6,7,2.01,5,-1,1.38);
insert into hypatia_test_bubble_multi1 values (8,2,0.2,9,5,3);

create table hypatia_test_bubble_multi2 (x float, y1 float, size1 float, y2 float, size2 float);
insert into hypatia_test_bubble_multi2 values (-1,2,4,-3,1);
insert into hypatia_test_bubble_multi2 values (1,1,0.4,5,1.21);
insert into hypatia_test_bubble_multi2 values (5,0,2,8,3);
insert into hypatia_test_bubble_multi2 values (6,-3,2,8,0.5);

create table hypatia_test_bubble_fail (x float, y float, z float, w float);
insert into hypatia_test_pie values ('some type',1);
insert into hypatia_test_pie values ('some other thing',2);
insert into hypatia_test_pie values ('some type',0.48);
insert into hypatia_test_pie values ('yet another thing',1.78);