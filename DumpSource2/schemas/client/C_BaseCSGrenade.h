// MConstructibleClassBase
class C_BaseCSGrenade : public C_CSWeaponBase
{
	bool m_bClientPredictDelete;
	bool m_bRedraw;
	bool m_bIsHeldByPlayer;
	bool m_bPinPulled;
	bool m_bJumpThrow;
	bool m_bThrowAnimating;
	GameTime_t m_fThrowTime;
	float32 m_flThrowStrength;
	GameTime_t m_fDropTime;
	GameTime_t m_fPinPullTime;
	bool m_bJustPulledPin;
	GameTick_t m_nNextHoldTick;
	float32 m_flNextHoldFrac;
	CHandle< C_CSWeaponBase > m_hSwitchToWeaponAfterThrow;
};
