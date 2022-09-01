# sccm-usb-infograbber
This will convert SCCM task sequence media so that it captures PC import info (serial/service tag, UUID/GUID and MAC address) to a USB key.

0. Copy this set of files to your hard drive.  This will not work if run from a network location.
1. Edit line 1 of maclist.ps1 and change the value of $prefix to something appropriate for you.  
If the serial/service tag of the computer is `A1B2C3D`, and you set the prefix to `PCNAME-`, the computer's name will be captured as `PCNAME-A1B2C3D`
2. Install the Windows ADK and PE addon.
3. Edit line 2 of thescript.bat to point to the Powershell PE files in the ADK.
4. Create an SCCM bootable USB key.
5. Drag sources\boot.wim onto thescript.bat  
The script will ask to elevate (dism needs admin rights), and it will generate a boot-modified.wim file in the same location as boot.wim
6. Rename boot-modified.wim to boot.wim
7. On the root of the USB key, create a file called LISTGOESHERE

You are ready to capture computer info
1. Plug the computer into the network if you want the MAC
2. Boot from the USB key
3. Info is captured to maclist.csv on the root of the USB key.  Red text generally means that the MAC did not get captured for some reason (usually network not plugged in, or driver not loaded on the boot key)



Look out for the message: `The specified package is not applicable to this image.`
You likely have the wrong version of the Windows ADK with PE addon installed.  Older versions of the ADK are further down the MS downloads page.

You can get the version of Windows on your boot key with the command
`dism /get-wiminfo /wimfile:p:\sources\boot.wim /index:1`
(where p: is the drive letter of your SCCM USB key)
