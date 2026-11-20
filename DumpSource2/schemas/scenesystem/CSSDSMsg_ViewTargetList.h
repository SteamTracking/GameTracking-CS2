class CSSDSMsg_ViewTargetList
{
	SceneViewId_t m_viewId; // = { "m_nFrameCount": 0, "m_nViewId": 0 }
	CUtlString m_ViewName;
	CUtlVector< CSSDSMsg_ViewTarget > m_Targets;
};
