##CONTENTS

###DEPLOYABLE BIKE 1.0.0

#####credits: original concept/code by player2/overhaul by mudzereli

This adds a deploy bike option when right clicking a toolbox. Requires CLICK ACTIONS (below).

###CLICK ACTIONS 1.0.5.1

#####credits: mudzereli

This is used to register right click actions on items. Required by other addons. Is an overwrite so may not be compatible with mods other than Epoch 1.0.5.1. Conflicts with anything else that overwrites ui_selectSlot.sqf (most likely any addon that adds right-click options).

-----

##Installation
 1. extract the contents of the zip file into your mission file root
 2. add these lines to the end of your mission file init.sqf.
      
```call compile preprocessFileLineNumbers "overwrites\click_actions\init.sqf";```

```call compile preprocessFileLineNumbers "addons\bike\init.sqf";```