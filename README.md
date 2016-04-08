# MS-DOS-ScreenShoot

### About the aplication

COM aplication written for MS-DOS 8086. The main functionality of the application is making a ScreenShoot. ScreenShoot is take as a copy of content of DOS windows and saved in a text file.

### Tools used

DosBox 0.74 - [link][df1]

NASM 2.12 - [link][df2]

### Compiling the code:

After starting MS DOS use comand:

```sh
nasm main.asm -f bin -o main.com
```

If you just want to run the application you cna use the provided binary.

### Running the aplication:

Aplication takes 2 command lines:

  -start filepath.txt
  
  -stop

Examples of working lines: 

```sh
main.com -start ss.txt
```



[df1]: http://www.dosbox.com/download.php?main=1
[df2]: http://www.nasm.us/pub/nasm/releasebuilds/2.12.01/
