// MHasKV3TransferPolymorphicClassname
class CModelConfigElement_AttachedModel : public CModelConfigElement
{
	CUtlString m_InstanceName;
	CUtlString m_EntityClass;
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
	Vector m_vOffset;
	QAngle m_aAngOffset;
	CUtlString m_AttachmentName;
	CUtlString m_LocalAttachmentOffsetName;
	ModelConfigAttachmentType_t m_AttachmentType; // = "MODEL_CONFIG_ATTACHMENT_ROOT_RELATIVE"
	bool m_bBoneMergeFlex;
	bool m_bUserSpecifiedColor;
	bool m_bUserSpecifiedMaterialGroup;
	CUtlString m_BodygroupOnOtherModels;
	CUtlString m_MaterialGroupOnOtherModels;
	bool m_bCollideWithHierarchy;
	bool m_bCollideOutsideHierarchy; // = true
};
