project "Client"
    kind "SharedLib"
    language "C#"
    csversion "latest"

    dotnetframework "4.8"

    GetGameDependencies("FiveM")

    nugetsource "https://api.nuget.org/v3/index.json"
    nuget {"System.Text.Json:8.0.3"}

    defines {
      "IS_CLIENT"
    }

    files {
      "src/**.cs",
      "../shared/**.cs"
    }

    links {
      "System.dll",
      "Microsoft.CSharp.dll",
      "System.Core.dll",
      "System.Text.Json.dll"
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