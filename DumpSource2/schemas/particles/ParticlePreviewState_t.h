class ParticlePreviewState_t
{
	CUtlString m_previewModel;
	uint32 m_nModSpecificData;
	PetGroundType_t m_groundType; // = "PET_GROUND_GRID"
	CUtlString m_sequenceName;
	int32 m_nFireParticleOnSequenceFrame;
	CUtlString m_hitboxSetName;
	CUtlString m_materialGroupName;
	CUtlVector< ParticlePreviewBodyGroup_t > m_vecBodyGroups;
	float32 m_flPlaybackSpeed; // = 1
	float32 m_flParticleSimulationRate; // = 1
	bool m_bShouldDrawHitboxes;
	bool m_bShouldDrawAttachments;
	bool m_bShouldDrawAttachmentNames;
	bool m_bShouldDrawControlPointAxes;
	bool m_bAnimationNonLooping;
	bool m_bSequenceNameIsAnimClipPath;
	Vector m_vecPreviewGravity; // = [ 0, 0, -800 ]
	Vector m_vecPreviewWind;
};
