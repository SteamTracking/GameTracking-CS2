class C_Hostage : public C_BaseCombatCharacter
{
	EntitySpottedState_t m_entitySpottedState;
	CHandle< C_BaseEntity > m_leader;
	CountdownTimer m_reuseTimer;
	Vector m_vel;
	bool m_isRescued;
	bool m_jumpedThisFrame;
	int32 m_nHostageState;
	bool m_bHandsHaveBeenCut;
	CHandle< C_CSPlayerPawn > m_hHostageGrabber;
	GameTime_t m_fLastGrabTime;
	VectorWS m_vecGrabbedPos;
	GameTime_t m_flRescueStartTime;
	GameTime_t m_flGrabSuccessTime;
	GameTime_t m_flDropStartTime;
	CountdownTimer m_blinkTimer;
	VectorWS m_lookAt;
	CountdownTimer m_lookAroundTimer;
	bool m_isInit;
	AttachmentHandle_t m_eyeAttachment;
	AttachmentHandle_t m_chestAttachment;
	CBasePlayerController* m_pPredictionOwner;
	GameTime_t m_fNewestAlphaThinkTime;
};
