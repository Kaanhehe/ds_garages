# ds_garage
A realistic garage script for FiveM utilizing a walk in garage system instead of boring menus and GUIs.

/!\ IMPORTANT: I WILL NOT PROVIDE ANY SUPPORT FOR PEOPLE WHO COME FOR HELP WITH THEIR OWN PROGRAMMING MODIFICATIONS ! 

Need help with the script ? Go into the support Discord https://discord.gg/Ap25HKBbg4
A verification that you bought the script will be necessary.

By default there is three language translations, french, english and german that you can find in the languages directory.
To load the one you want, please modify the fxmanifest file and change the "languages/english.lua" to whatever file in LUA with same structure.

## Note for modifications on the script:

server/api.lua will allow you to:
- custom what happens when you disconnect from the server
- custom the verification for plate ownership

client/utils.lua will allow you to:
- custom format money
- custom notifications
- custom remove vehicle logic
- custom the way to get vehicle properties 
- custom the way to set vehicle properties 

## Installation:
Download the pmc-instance https://github.com/Kaanhehe/pmc-instance

Download menuv https://github.com/ThymonA/menuv/releases/download/v1.4.1/menuv_v1.4.1.zip

### Step 1:
Place the script pmc-instance in your resources directory.
Place the script menuv in your resources directory.
Place the garage script in your resources directory.

### Step 2:
Add the sql lines from migration.sql into your database.

### Step 3:
Add
```
ensure pmc-instance
ensure menuv
ensure ds_garage
```
to your server.cfg
make sure to start pmc-instance and menuv before ds_garage to avoid any issues.

### Step 4:
Configure the config.lua to your liking.