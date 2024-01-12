# ds_garage
A realistic garage script for FiveM utilizing a walk in garage system instead of boring menus and GUIs.

### IMPORTANT: I WILL NOT PROVIDE ANY SUPPORT FOR PEOPLE WHO COME FOR HELP WITH THEIR OWN PROGRAMMING MODIFICATIONS ! 

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
```bash
cd resources
git clone https://github.com/Kaanhehe/pmc-instance.git
```
Download menuv https://github.com/ThymonA/menuv/releases
Make sure to download the release of menuv and not the source code you download via the green button.
To download on windows:
```bash
cd resources
mkdir menuv
cd menuv
curl -LJO https://github.com/ThymonA/menuv/releases/download/v1.4.1/menuv_v1.4.1.zip
tar -xf menuv_v1.4.1.zip
del menuv_v1.4.1.zip
```
To download on linux:
```sh
cd resources
mkdir menuv
cd menuv
wget https://github.com/ThymonA/menuv/releases/download/v1.4.1/menuv_v1.4.1.zip
unzip menuv_v1.4.1.zip
rm menuv_v1.4.1.zip
```
Download ox_lib https://github.com/overextended/ox_lib/releases/latest/download/ox_lib.zip
Make sure to download the release of ox_lib and not the source code you download via the green button.
To download on windows:
```bash
cd resources
curl -LJO https://github.com/overextended/ox_lib/releases/latest/download/ox_lib.zip
tar -xf ox_lib.zip
del ox_lib.zip
```
To download on linux:
```sh
cd resources
wget https://github.com/overextended/ox_lib/releases/latest/download/ox_lib.zip
unzip ox_lib.zip
rm ox_lib.zip
```

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