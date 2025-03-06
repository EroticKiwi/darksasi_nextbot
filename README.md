This GMOD Addon is a way for me (EroticKiwi) to learn GLUA and the way it works, so this is educational material. 
Material found in here may not be 100% correct to GLUA's actual documentation so I'd recommend you check that to get a clear idea of GLUA.

TABLE OF CONTENTS:

1) ADDON STRUCTURE
2) IMPORTANT FUNCTIONS AND METHODS
3) DETAILS


**1 - ADDON STRUCTURE**

As far as my understanding goes, a gmod addon works following this file/directory structure:
*[] = DIRECTORY*
*[*] = OPTIONAL DIRECTORY*
*$ = file*

[**AddonName**]
    |_ _ [**lua**] {contains all of our code}
             |_ _ [**autorun**]
                        |_ _ [**server**] {contains code that will be ran SERVER-SIDE}
                        |_ _ [**client**] {contains code that will be ran CLIENT-SIDE}
                        |_ _ $shared {contains code that will be shared between server and client}
              |_ _ [***other folders**]
    |_ _ [***materials**] {contains materials...only to be included if our addon needs custom materials}
                |_ _ [***other folder**]
    |_ _ [***models**] {contains models...only to be included if our addon needs custom models}
