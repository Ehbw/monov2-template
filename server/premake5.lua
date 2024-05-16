project "Server"
    kind "SharedLib"
    language "C#"
    csversion "latest"

    dotnetframework "4.8"

    GetGameDependencies("Server")

    nugetsource "https://api.nuget.org/v3/index.json"
    nuget {"System.Text.Json:8.0.3"}

    files {
      "src/**.cs",
      "../shared/**.cs"
    }

    defines {
      "IS_SERVER"
    }

    links {
      "System.dll",
      "Microsoft.CSharp.dll",
      "System.Core.dll"
    }

    filter "configurations:Debug"
       defines { "DEBUG" }
       runtime "Debug"
       symbols "On"

    filter "configurations:Release"
       defines { "RELEASE" }
       runtime "Release"
       optimize "On"
       symbols "On"