// MHasKV3TransferPolymorphicClassname
class CAnimReplayFrame
{
	CUtlVector< CUtlBinaryBlock > m_inputDataBlocks;
	CUtlBinaryBlock m_instanceData; // = "[BINARY BLOB]"
	CTransform m_startingLocalToWorldTransform; // = [ 0, 0, 0, 1, 0, 0, 0, 1 ]
	CTransform m_localToWorldTransform; // = [ 0, 0, 0, 1, 0, 0, 0, 1 ]
	float32 m_timeStamp;
};
