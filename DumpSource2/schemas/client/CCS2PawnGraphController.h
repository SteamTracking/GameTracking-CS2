// MHasKV3TransferPolymorphicClassname
class CCS2PawnGraphController : public CCS2WeaponGraphController
{
	CAnimGraph2ParamOptionalRef< bool > m_bIsDefusing;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_moveType;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_moveDirectionID;
	CAnimGraph2ParamOptionalRef< float32 > m_flMoveSpeedX;
	CAnimGraph2ParamOptionalRef< float32 > m_flMoveSpeedY;
	CAnimGraph2ParamOptionalRef< float32 > m_flMoveSpeedHorizontal;
	CAnimGraph2ParamOptionalRef< float32 > m_flPreviousMoveSpeedHorizontal;
	CAnimGraph2ParamOptionalRef< float32 > m_flCrouchAmount;
	CAnimGraph2ParamOptionalRef< bool > m_bIsWalking;
	CAnimGraph2ParamOptionalRef< float32 > m_flWeaponDropAmount;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_groundAction;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_groundActionDirectionID;
	CAnimGraph2ParamOptionalRef< float32 > m_flGroundTurnAngleOrVelocity;
	CAnimGraph2ParamOptionalRef< float32 > m_flLadderCycle;
	CAnimGraph2ParamOptionalRef< float32 > m_flLadderYaw;
	CAnimGraph2ParamOptionalRef< float32 > m_flLadderYawBackwards;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_airAction;
	CAnimGraph2ParamOptionalRef< float32 > m_flAirHeightAboveGround;
	CAnimGraph2ParamOptionalRef< CNmTarget > m_leftFootTarget;
	CAnimGraph2ParamOptionalRef< CNmTarget > m_rightFootTarget;
	CAnimGraph2ParamOptionalRef< float32 > m_flFlashedAmount;
	CAnimGraph2ParamOptionalRef< float32 > m_flAimPitchAngle;
	CAnimGraph2ParamOptionalRef< float32 > m_flAimYawAngle;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_flinchHead;
	CAnimGraph2ParamOptionalRef< bool > m_flinchHeadRestart;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_flinchBody;
	CAnimGraph2ParamOptionalRef< bool > m_flinchBodyRestart;
	CAnimGraph2ParamOptionalRef< bool > m_flinchIsOnFire;
};
