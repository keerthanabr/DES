clear all;
close all;
clc;

%Input 64 bit key and Message(plain text)
Message= input('Enter the Message','s'); % sample input: Hi everyone 
key=input('Enter the Key(Exactly 8 characters)','s'); %sample key:12345678

len=length(Message)*8;
Message=dec2bin(Message,8)-'0';
Message=transpose(Message);
Message=reshape(Message,[1,len]) ; 
Message_=strrep(num2str(Message),' ','') %to print the message in binary form

key=dec2bin(key,8)-'0';
key=transpose(key);
key=reshape(key,[1,64]);

n=len/64;
n=fix(n);

if mod(len,64)~=0
    n=n+1;
    Message=[Message zeros(1,((64*n)-len))];   %Padding
end

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
M=Message(p1:p2);
p1=p2+1;

IP=[58 50 42 34 26 18 10 2 60 52 44 36 28 20 12 4 62 54 46 38 30 22 14 6 64 56 48 40 32 24 16 8 57 49 41 33 25 17 9 1 59 51 43 35 27 19 11 3 61 53 45 37 29 21 13 5 63 55 47 39 31 23 15 7];
IPM=zeros(1,64);
for i=1:64
    IPM(i)=M(IP(i));
end

L0=IPM(1:32);
R0=IPM(33:64);

for i=1:16
   L=R0;
   R=xor(L0,f_func(R0,K(:,:,1,i)));
   L0=L;
   R0=R;   
end

RL=[R L];

% Inverse Initial Permutation(IPI)
IPI=[40 8 48 16 56 24 64 32 39 7 47 15 55 23 63 31 38 6 46 14 54 22 62 30 37 5 45 13 53 21 61 29 36 4 44 12 52 20 60 28 35 3 43 11 51 19 59 27 34 2 42 10 50 18 58 26 33 1 41 9 49 17 57 25];
CT=zeros(1,64);
for i=1:64
 CT(i)=RL(IPI(i));
end
Cipher_text(:,:,1,j)=CT;
end
Cipher_text=reshape(Cipher_text,[1,p2]);
Cipher_text=num2str(reshape(Cipher_text,8,[]).');
Cipher=strrep(reshape(Cipher_text.',1,[]),' ','') %to print cipher in binary format
Cipher_text=reshape(char(bin2dec(Cipher_text)),1,[]) % to print cipher text


