This GMOD Addon is a way for me (EroticKiwi) to learn GLUA and the way it works, so this is educational material. 
Material found in here may not be 100% correct to GLUA's actual documentation so I'd recommend you check that to get a clear idea of GLUA.

TABLE OF CONTENTS:

1) ADDON STRUCTURE
2) IMPORTANT FUNCTIONS AND METHODS
3) DETAILS

---

**LEGEND**
* `[]`: = DIRECTORY
* `*[]` = OPTIONAL DIRECTORY
* `$` = file

---

**1 - ADDON STRUCTURE**

As far as my understanding goes, a gmod addon works following this file/directory structure:

* `[lua]`: {contains all of the addon's code}
    * `[autorun]`: {{contains code that will be ran when the server starts up}}
        * `[server]`: {{contains code that will be ran SERVER-SIDE}}
        * `[client]`: {{contains code that will be ran CLIENT-SIDE}}
        * `$shared`: {{contains code that is shared between server and code, usually utility functions}}
    * `*[other folders]`
* `*[materials]`: {{contains materials...needed only if our addon needs custom materials}}
* `*[models]`: {{contains models...needed only if our addon needs custom models}}
