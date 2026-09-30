class CAnimEncodedFrames
{
	CBufferString m_fileName;
	int32 m_nFrames;
	int32 m_nFramesPerBlock;
	CUtlVector< CAnimFrameBlockAnim > m_frameblockArray;
	CAnimEncodeDifference m_usageDifferences;
};
