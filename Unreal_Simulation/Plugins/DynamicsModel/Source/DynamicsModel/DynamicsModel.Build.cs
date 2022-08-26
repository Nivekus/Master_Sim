// Copyright Epic Games, Inc. All Rights Reserved.

using UnrealBuildTool;
using System.IO;

public class DynamicsModel : ModuleRules
{
	public DynamicsModel(ReadOnlyTargetRules Target) : base(Target)
	{

        PublicDependencyModuleNames.AddRange(new string[] {  "Boost"});


        PCHUsage = ModuleRules.PCHUsageMode.UseExplicitOrSharedPCHs;
        //Type = ModuleType.External;

        PublicIncludePaths.AddRange(
			new string[] {
                Path.Combine(ModuleDirectory,"Public"),
            }
			);

        //PublicAdditionalLibraries.Add(Path.Combine(ModuleDirectory, "DynamicsModel.lib"));

        PrivateIncludePaths.AddRange(
			new string[] {
				// ... add other private include paths required here ...
				Path.Combine(ModuleDirectory,"Private")

            }
            );
			
		
		PublicDependencyModuleNames.AddRange(
			new string[]
			{
				"Core",
				"DynamicsModelLibrary",
				"Projects"
				// ... add other public dependencies that you statically link with here ...
			}
			);
			
		
		PrivateDependencyModuleNames.AddRange(
			new string[]
			{
				// ... add private dependencies that you statically link with here ...	
			}
			);
		
		
		DynamicallyLoadedModuleNames.AddRange(
			new string[]
			{
				// ... add any modules that your module loads dynamically here ...
			}
			);
	}
}
