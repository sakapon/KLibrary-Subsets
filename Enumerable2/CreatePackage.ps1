..\Tools\NuGet.CommandLine.3.4.3\NuGet.exe pack Package.nuspec

move *.nupkg ..\Published -Force
explorer ..\Published
