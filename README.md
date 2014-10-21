wifi-hosted-network
===================

This batch script will help you to configure a virtual wireless access point with the new version of Windows operating systems, starting from Windows 7. The virtual wireless access point behaves similar to hardware wireless access point with some limitations.

Here are some known limitations of Windows hosted network stack.

1. The wireless type is always set as WPA2-personal. Passphrase is required. This setup is convenient for personal/home use only.

2. No support for other wireless types. Don't expect to run a WPA enterprise solution with client version. I haven't tested the server version, so that I have no idea whether the server version supports more wireless type, such as WPA2-Enterprise with external Radius server. If you need to run more advanced wireless access point setup, it's better to use [Hostapd](http://w1.fi/hostapd), which runs on GNU/Linux and BSD.

3. If you don't care about those limitations, go ahead and taste the hosted network feature of Windows.

-----------
How to use:
-----------

Simply right click on the cmd file and choose Run as administrator.
You may launch this script from an admin cmd window.

You can setup windows hostednetwork SSID and passphrase, start hostednetwork, and stop it. Just choose the appropriate number and you are ready to go.

---------------------------------
Advantage over other similar apps
---------------------------------
1. Easy to use.
2. No need to install additional software. Easier on system resource.
3. Share your internet connection with your devices.

-------
License
-------
MIT License. See [LICENSE](./LICENSE.md)
