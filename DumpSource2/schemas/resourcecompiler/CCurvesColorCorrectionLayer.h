// MHasKV3TransferPolymorphicClassname
class CCurvesColorCorrectionLayer : public CColorCorrectionLayer
{
	CUtlVector< Vector2D > m_curvePointsRGB; // = [ [ 0, 0 ], [ 255, 255 ] ]
	CUtlVector< Vector2D > m_curvePointsR; // = [ [ 0, 0 ], [ 255, 255 ] ]
	CUtlVector< Vector2D > m_curvePointsG; // = [ [ 0, 0 ], [ 255, 255 ] ]
	CUtlVector< Vector2D > m_curvePointsB; // = [ [ 0, 0 ], [ 255, 255 ] ]
};
