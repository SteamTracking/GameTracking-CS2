// MModelGameData
// MFgdHelper = "game_data_list{ key = 'CNPCPhysicsHull' }"
// MFgdHelper = "npcphysicshull{}"
// MCustomFGDMetadata = "{ node_name_key = 'm_sName' }"
class CNPCPhysicsHull
{
	// MPropertyFriendlyName = "Name"
	// MPropertySuppressField
	CGlobalSymbol m_sName;
	// MPropertyFriendlyName = "Type"
	NPCPhysicsHullType_t m_eType; // = "eInvalid"
	// MPropertySuppressExpr = "m_eType != eGroundCapsule && m_eType != eCenteredCapsule && m_eType != eCenteredCylinder && m_eType != eGroundCylinder"
	// MPropertyFriendlyName = "Height"
	float32 m_flCapsuleHeight; // = 50
	// MPropertySuppressExpr = "m_eType != eGroundCapsule && m_eType != eGenericCapsule && m_eType != eCenteredCapsule && m_eType != eCenteredCylinder && m_eType != eGroundCylinder"
	// MPropertyFriendlyName = "Radius"
	float32 m_flCapsuleRadius; // = 11
	// MPropertySuppressExpr = "m_eType != eGenericCapsule"
	// MPropertyFriendlyName = "Center 1"
	Vector m_vCapsuleCenter1; // = [ 0, 0, 11 ]
	// MPropertySuppressExpr = "m_eType != eGenericCapsule"
	// MPropertyFriendlyName = "Center 2"
	Vector m_vCapsuleCenter2; // = [ 0, 0, 61 ]
	// MPropertySuppressExpr = "m_eType != eGroundBox"
	// MPropertyFriendlyName = "Height"
	float32 m_flGroundBoxHeight; // = 50
	// MPropertySuppressExpr = "m_eType != eGroundBox"
	// MPropertyFriendlyName = "Width"
	float32 m_flGroundBoxWidth; // = 11
};
