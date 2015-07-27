AddCSLuaFile();

local POST_URL = "fill me in or i wont love you"; -- the url for post requests (serverside)

print"Loading august-2015-contest lua...";


-- no access for detours
local noaccess = {};

local function denyaccess(f)
    noaccess[f] = true;
end

local function allowedaccess(f)
    return not noaccess[f];
end


local debug_getupvalue = debug.getupvalue;

function debug.getupvalue(f, ...)
    
    if(not allowedaccess(f)) then return nil, nil; end
    
    local name, value = debug_getupvalue(f, ...);
    
    if(not allowedaccess(value)) then return nil, nil; end
    
    return name,value;
    
end


local debug_setupvalue = debug.setupvalue;

function debug.setupvalue(f, index, ...)
    
    local name, value = debug_getupvalue(f, index);
    
    if(not allowedaccess(value)) then return nil; end
    
    return debug_setupvalue(f, index, ...);
    
end

denyaccess(debug.getupvalue);
denyaccess(debug_getupvalue);
denyaccess(debug.setupvalue);
denyaccess(debug_setupvalue);


local old_HTTP = HTTP;

function HTTP(data)
    
    if(not data) then return; end;
    
    -- todo: make better url comparisons
    
    if(data.url and data.url == POST_URL or data.method and data.method == "POST" or not data.method or not data.url) then
        
        if(data.failed) then data.failed"FUCK OFF"; return; end
        
    end
    
    old_HTTP(data);
    
end

denyaccess(HTTP);
denyaccess(old_HTTP);


local init_old = file.Open("lua/includes/init.lua", "rb", "GAME");

local init_contents = init_old:Read(init_old:Size());

local init_fn = CompileString(init_contents, "lua/includes/init.lua", true);

init_fn();