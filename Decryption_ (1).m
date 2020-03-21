clear all;
close all;
clc;

%Input 64 bit key and Cipher Text
%CT=[1 0 0 0 0 1 0 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1 1 0 1 0 1 0 1 0 0 0 0 0 0 1 1 1 1 0 0 0 0 1 0 1 0 1 0 1 1 0 1 0 0 0 0 0 0 0 1 0 1];
%key=[0 0 0 1 0 0 1 1 0 0 1 1 0 1 0 0 0 1 0 1 0 1 1 1 0 1 1 1 1 0 0 1 1 0 0 1 1 0 1 1 1 0 1 1 1 1 0 0 1 1 0 1 1 1 1 1 1 1 1 1 0 0 0 1];

Cipher= input('Enter the Cipher','s');
key=input('Enter the Key(Exactly 8 characters)','s');
Cipher=char(num2cell(Cipher));
Cipher=reshape(str2num(Cipher),1,[]);

len=length(Cipher);

key=dec2bin(key,8)-'0';
key=transpose(key);
key=reshape(key,[1,64]);

n=len/64;

% 56 bit pc_1
pc_1=[57 49 41 33 25 17 9 1 58 50 42 34 26 18 10 2 59 51 43 35 27 19 11 3 60 52 44 36 63 55 47 39 31 23 15 7 62 54 46 38 30 22 14 6 61 53 45 37 29 21 13 5 28 20 12 4];

%passing key through pc_1 to obtain 56 bit key
K_pc=zeros(1,56);
for i=1:56
 K_pc(i)=key(pc_1(i));
end

%key generation K1 to K16
C=zeros(1,28,1,17);
D=zeros(1,28,1,17);
K=zeros(1,48,1,17);

[C(:,:,1,1),D(:,:,1,1)]=Key(K_pc,0);
for i=2:17
   [C(:,:,1,i),D(:,:,1,i),K(:,:,1,i-1)]=Key([C(:,:,1,i-1) D(:,:,1,i-1)],i-1); 
end

% looping for every 64 bits
p1=1;
for j=1:n
p2=64*j;
CT=Cipher(p1:p2);
p1=p2+1;

IP=[58 50 42 34 26 18 10 2 60 52 44 36 28 20 12 4 62 54 46 38 30 22 14 6 64 56 48 40 32 24 16 8 57 49 41 33 25 17 9 1 59 51 43 35 27 19 11 3 61 53 45 37 29 21 13 5 63 55 47 39 31 23 15 7];
IPM=zeros(1,64);
for i=1:64
    IPM(i)=CT(IP(i));
end


L0=IPM(1:32);
R0=IPM(33:64);


for i=1:16
   L=R0;
   R=xor(L0,f_func(R0,K(:,:,1,17-i)));
   L0=L;
   R0=R;    
end
RL=[R L];

% Inverse Initial Permutation(IPI)
IPI=[40 8 48 16 56 24 64 32 39 7 47 15 55 23 63 31 38 6 46 14 54 22 62 30 37 5 45 13 53 21 61 29 36 4 44 12 52 20 60 28 35 3 43 11 51 19 59 27 34 2 42 10 50 18 58 26 33 1 41 9 49 17 57 25];
M=zeros(1,64);
for i=1:64
 M(i)=RL(IPI(i));
end

Message_text(:,:,1,j)=M;
end
Message_text=reshape(Message_text,[1,p2]);
Message_text=num2str(reshape(Message_text,8,[]).');
Message=strrep(reshape(Message_text.',1,[]),' ','') %to print message in binary format
Message_text=reshape(char(bin2dec(Message_text)),1,[]) % to print the message