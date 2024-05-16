outputdir = "%{cfg.buildcfg}-%{cfg.system}"
distDir = path.getabsolute("./dist")
depDir = path.getabsolute("./dependencies")
mainDir = path.getabsolute(".")

require "vstudio"

--- Example code to further customisation premake project configuration 
--[[
local function platformsElement(cfg)
    local action = premake.action.current()

    _p(2, "<OutputType>Library</OutputType>")
    _p(2, "<TargetFrameworkVersion>v4.5.2</TargetFrameworkVersion>")
    _p(2, "<Platforms>x64</Platforms>")
    _p(2, ("<AssemblyName>%s.net</AssemblyName>"):format(cfg.buildtarget.basename))
end

premake.override(premake.vstudio.cs2005.elements, "projectProperties", function (oldfn, cfg)
  return {platformsElement}
end)
]]

premake.override(premake.vstudio.dotnetbase, "targetFrameworkVersion", function (base, cfg)
    base(cfg)
end)

---Sets assemblyname to match CFX's mono scrt expectation of .net.dll filenames  
premake.override(premake.vstudio.dotnetbase, "assemblyName", function (_, cfg)
    _p(2, ("<AssemblyName>%s.net</AssemblyName>"):format(cfg.buildtarget.basename))
end)

local prevPercent = 0
local function progress(total, current)
    local ratio = current / total;
    ratio = math.min(math.max(ratio, 0), 1);
    local percent = math.floor(ratio * 100);
    if prevPercent ~= percent then
        prevPercent = percent
        print("Download progress (" .. percent .. "%/100%)")
    end
end

---Finds and copies Mono V2 dlls for the game provided and stores them in dependencies
---@param game 'Server' | 'LibertyM' | 'RedM' | 'FiveM'
function FetchGameDependencies(game)
    if not os.isdir(depDir) then
        os.mkdir(depDir)
        os.chmod(depDir, 755)
    end

    if game == 'Server' then
        local body, _, code = http.get("https://changelogs-live.fivem.net/api/changelog/versions/win32/server")
        if code == 200 then
            local data = json.decode(body)
            local _, response = http.download(data.latest_download, "dependencies/server.zip", {
                progress = progress
            })

            if response == 200.0 then
                zip.extract("dependencies/server.zip", "dependencies/artifact")
                os.remove("dependencies/server.zip")
                local monoV2Dir = ("%s/artifact/citizen/clr2/lib/mono/4.5/v2/"):format(depDir)
                print(monoV2Dir)
                os.copyfile(("%sCitizenFX.Core.dll"):format(monoV2Dir), ("%s/CitizenFX.Core.dll"):format(depDir))
                os.copyfile(("%sCitizenFX.Server.dll"):format(monoV2Dir), ("%s/CitizenFX.Server.dll"):format(depDir))
            end
        end
        return
    end

    local monoV2Dir = ("%s/%s/%s.app/citizen/clr2/lib/mono/4.5/v2/"):format(os.getenv("localappdata"), game, game)
    if os.isdir(monoV2Dir) then
      os.copyfile(("%sCitizenFX.Core.dll"):format(monoV2Dir), ("%s/CitizenFX.Core.dll"):format(depDir))
      os.copyfile(("%sCitizenFX.%s.dll"):format(monoV2Dir, game), ("%s/CitizenFX.%s.dll"):format(depDir, game))
      os.copyfile(("%sNative/CitizenFX.%s.Native.dll"):format(monoV2Dir, game), ("%s/CitizenFX.%s.Native.dll"):format(depDir, game))
      return
    end
    error(("Unable to retrieve mono v2 %s dll(s) at %s"):format(game, monoV2Dir))
end

---@param game 'Server' | 'LibertyM' | 'RedM' | 'FiveM'
function GetGameDependencies(game)
    if game == 'Server' then
        links
        {
            ("%s/CitizenFX.Core.dll"):format(depDir),
            ("%s/CitizenFX.Server.dll"):format(depDir)
        }
    else
        links
        {
            ("%s/CitizenFX.Core.dll"):format(depDir),
            ("%s/CitizenFX.%s.dll"):format(depDir, game),
            ("%s/CitizenFX.%s.Native.dll"):format(depDir, game)
        }
    end
end

FetchGameDependencies('Server')
FetchGameDependencies('FiveM')

workspace "project"
    architecture "x86_64"

    configurations
    {
        "Debug",
        "Release"
    }

    postbuildcommands
    {
        ("{COPYFILE} %s/fxmanifest.lua %s/fxmanifest.lua"):format(mainDir, distDir)
    }

    targetdir ("dist/%{prj.name}")
    objdir ("bin/%{prj.name}")

    include "client"
    include "server"