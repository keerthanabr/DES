function [C,D,K_2]=Key(K_1,flag)

% 48 bit pc_2
pc_2=[14 17 11 24 1 5 3 28 15 6 21 10 23 19 12 4 26 8 16 7 27 20 13 2 41 52 31 37 47 55 30 40 51 45 33 48 44 49 39 56 34 53 46 42 50 36 29 32];

%left and right part of key
 C=K_1(1:28);
 D=K_1(29:56);
 
%shifting operation
 if flag==0
     C=C;
     D=D;   
 elseif (flag==1)||(flag==2)||(flag==9)||(flag==16)
    C=[C(2:28) C(1)];
    D=[D(2:28) D(1)];
 else   
    C=[C(3:28) C(1:2)];
    D=[D(3:28) D(1:2)];
 end
K_1=[C D];
 
%passing key through pc_2
K_2=zeros(1,48);
for i=1:48
 K_2(i)=K_1(pc_2(i));
end
end

 