class CVMixToolDoc
{
	// MKV3TransferName = "dsp"
	CVMixToolEffectsList m_dspPresets;
	CEffectsPreviewList m_effectsPreview; // = { "m_flMix": 1, "m_previewGraphInput": "", "m_previewList": { "m_bPreviewInGame": false, "m_sounds": [  ] } }
	// MKV3TransferName = "Graphs"
	CUtlVector< CVMixToolGraphEntry > m_graphs;
	// MKV3TransferName = "Editor"
	CVMixToolEditorData m_editorData; // = { "SelectedGraph": -1, "m_nSelectedEffectPreset": -1 }
};
