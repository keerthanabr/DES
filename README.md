# DES
DES algorithm implimented in Matlab

The Data Encryption Standard is a symmetric-key algorithm for the encryption of digital data.
DES is an implementation of a Feistel Cipher. It uses 16 round Feistel structure. The block size is 64-bit. Though, key length is 64-bit, DES has an effective key length of 56 bits, since 8 of the 64 bits of the key are not used by the encryption algorithm.
DES works by using the same key to encrypt and decrypt a message, so both the sender and the receiver must know and use the same private key.

The whole program is divided into following parts:
i.   Key function: to generate 16 subkeys
ii.  F function: to impliment the F block
iii. Encryption: main program to generate Cipher text
iv.  Decrytion: main program to decrypt
