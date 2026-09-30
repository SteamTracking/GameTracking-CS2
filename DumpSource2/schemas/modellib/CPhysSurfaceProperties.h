class CPhysSurfaceProperties
{
	// MKV3TransferName = "surfacePropertyName"
	CUtlString m_name;
	uint32 m_nameHash;
	uint32 m_baseNameHash;
	// MKV3TransferName = "hidden"
	bool m_bHidden;
	// MKV3TransferName = "description"
	CUtlString m_description;
	// MKV3TransferName = "physics"
	CPhysSurfacePropertiesPhysics m_physics; // = { "density": 0, "elasticity": 0, "friction": 0, "softcontactdampingratio": 0, "softcontactfrequency": 0, "thickness": 0.1 }
	// MKV3TransferName = "vehicleparams"
	CPhysSurfacePropertiesVehicle m_vehicleParams; // = { "wheeldrag": 0, "wheelfrictionscale": 1 }
	// MKV3TransferName = "audiosounds"
	CPhysSurfacePropertiesSoundNames m_audioSounds;
	// MKV3TransferName = "audioparams"
	CPhysSurfacePropertiesAudio m_audioParams;
};
