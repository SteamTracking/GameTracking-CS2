"GameInfo"
{
	//
	// Branch-varying info, such as the game/title and app IDs, is in gameinfo_branchspecific.gi.
	// gameinfo.gi is the non-branch-varying content and can be integrated between branches.
	//

	FileSystem
	{
		ForceFixedAppIds	1
		SteamAppId			730
		BreakpadAppId			2347771
		BreakpadAppId_Tools		2347779
	}

	Panorama
	{
		"PreprocessResources"	  "1"			// Removes comments/devonly sections/devmsg etc.. from css,xml,js,ts
	}

	ConVars
	{
		"cl_usesocketsforloopback" "0"
	}

}
