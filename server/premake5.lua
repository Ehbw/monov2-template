project "Server"
    kind "SharedLib"
    language "C#"
    csversion "latest"

    dotnetframework "4.5.2"

    GetGameDependencies("Server")

    files {
      "src/**.cs",
      "../shared/**.cs"
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