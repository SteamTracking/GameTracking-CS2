class CAnimBone
{
	CBufferString m_name;
	int32 m_parent;
	Vector m_pos;
	QuaternionStorage m_quat; // = [ 0, 0, 0, 1 ]
	float32 m_scale; // = 1
	QuaternionStorage m_qAlignment; // = [ 0, 0, 0, 1 ]
	int32 m_flags;
};
