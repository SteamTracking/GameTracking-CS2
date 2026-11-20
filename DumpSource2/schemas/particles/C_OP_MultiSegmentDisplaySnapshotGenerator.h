// MHasKV3TransferPolymorphicClassname
class C_OP_MultiSegmentDisplaySnapshotGenerator : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "snapshot control point number"
	int32 m_nCPSnapshot;
	// MPropertyFriendlyName = "Segment Count"
	ParticleMultiSegmentCountSelection_t m_nSegCount; // = "PARTICLE_MULTISEGMENT_SEG_COUNT_7"
	// MPropertyFriendlyName = "Input Type"
	ParticleMultiSegmentInputSelection_t m_nInputType; // = "PARTICLE_MULTISEGMENT_SELECTION_FLOAT"
	// MPropertyFriendlyName = "Default String"
	// MPropertySuppressExpr = "m_nInputType != PARTICLE_MULTISEGMENT_SELECTION_STRING"
	CUtlString m_strDefaultString;
	// MPropertyFriendlyName = "Float Value"
	// MPropertySuppressExpr = "m_nInputType != PARTICLE_MULTISEGMENT_SELECTION_FLOAT"
	CParticleCollectionFloatInput m_flValue;
	// MPropertyFriendlyName = "Scroll Offset"
	CParticleCollectionFloatInput m_flScollOffset;
	// MPropertyFriendlyName = "Segment Special Character"
	CUtlVector< ParticleMultiSegmentSpecialCharacter_t > m_SpecialCharList;
	// MPropertyFriendlyName = "unlit segment color"
	CParticleCollectionVecInput m_vecColorUnlit; // = { "m_LiteralColor": [ 5, 5, 5 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "lit segment color"
	CParticleCollectionVecInput m_vecColorLit; // = { "m_LiteralColor": [ 255, 0, 0 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "Radius"
	CParticleCollectionFloatInput m_flRadius; // = { "m_flLiteralValue": 5 }
	// MPropertyFriendlyName = "Spacing Scale"
	CParticleCollectionFloatInput m_flSpacing; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Minimum Digits Count"
	CParticleCollectionFloatInput m_flMinCount; // = { "m_flLiteralValue": 3 }
	// MPropertyFriendlyName = "Maximum Digits Count"
	CParticleCollectionFloatInput m_flMaxCount; // = { "m_flLiteralValue": 3 }
	// MPropertyFriendlyName = "Prepend Empty Digits"
	bool m_bPrependEmpty; // = true
	// MPropertyFriendlyName = "Digits After Decimal"
	// MPropertySuppressExpr = "m_nInputType != PARTICLE_MULTISEGMENT_SELECTION_FLOAT"
	CParticleCollectionFloatInput m_flDigitsAfterDecimal; // = { "m_flLiteralValue": 1 }
};
