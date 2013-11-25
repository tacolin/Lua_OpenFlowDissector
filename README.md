open_flow_dissector
===================

SDN Open Flow Message Wireshark Dissector

How to install this dissector to wireshark ?

[Windows]

1) Download the wirewhark portable version

2) make sure that you can execute wireshark successfully in your computer

3) put the "ofp_1_x_x.lua" to the \WiresharkPortable\App\Wireshark\

4) open the "init.lua" in the \WiresharkPortable\App\Wireshark\

5) go to the bottom of "init.lua", and add the following line:

...
dofile(DATA_DIR.."console.lua")
dofile(DATA_DIR.."ofp_1_x_x.lua") -- this line

6) restart wireshark, it works

===================

[Ubuntu (Linux)]

1) sudo apt-get install wireshark

2) make sure that you have installed lua5.1 on your computer 

3) make sure that you can execute wireshark successfully in your computer without sudo

if you don't known how to do, you could see this place:
http://goo.gl/KnTGwQ

4) put the "ofp_1_x_x.lua" to the /usr/share/wireshark/

5) open the "init.lua" in the /usr/share/wireshark/

6) goto the bottom of "init.lua", and add the following line:

...
dofile(DATA_DIR.."console.lua")
dofile(DATA_DIR.."ofp_1_x_x.lua") -- this line

7) restart wireshark, it works
