class CVMixToolGraph
{
	// MKV3TransferName = "Name"
	CUtlString m_name;
	int32 m_nGraphOutputChannels; // = -1
	bool m_bIsMainGraph;
	int32 m_nPreviewNode;
	// MKV3TransferName = "m_EditorNodes"
	CUtlVector< CVMixEditorNode > m_editorNodes;
	// MKV3TransferName = "m_EditorEdges"
	CUtlVector< CVMixEditorEdge > m_editorEdges;
};
