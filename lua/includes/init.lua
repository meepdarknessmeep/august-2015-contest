AddCSLuaFile();

print"Loading august-2015-contest lua...";



-- let's detour some fun things soon



local init_old = file.Open("lua/includes/init.lua", "rb", "GAME");

local init_contents = init_old:Read(init_old:Size());

local init_fn = CompileString(init_contents, "lua/includes/init.lua", true);

init_fn();