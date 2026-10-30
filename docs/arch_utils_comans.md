

#In this readmy file create the list of the commands to use in the arch for config and get the system informacion.

list the mointors on in the pc 
```bash
xrandr --verbose
xrandr --query ## not visualize all ditals 
```

Forse the close of the prgram
```bas
kill -9 <pid>
```

Return the pid of the porgar at use the port specific 
```bash
lsof -t -i:8080
```

Use for identify the type class of file 
And secund command use the type for identify the program for open the file
```bash 
xdg-mime query filetype arquivo.ext
xdg-mime query default <class of file>

```

# Grab the pc Srcrean use the comand 
```bash 
  wf-recorder --audio -f ~/Videos/gravacao-$(date +%F-%H%M%S).mp4
```

# Mount the windos disk 
```bash
sudo mount -t ntfs-3g /dev/nvme0n1p4 /home/joao41/disks
``` 


# Chek boot errors 

```bash
 sudo journalctl -p 3 -xb
```

# Visualze structr of directory for use tree 
```bash
tree -L 4 -I '.git|.gradle|build'
```
