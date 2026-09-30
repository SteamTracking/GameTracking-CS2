// MHasKV3TransferPolymorphicClassname
class fogparams_t
{
	Vector dirPrimary; // = [ 1, 0, 0 ]
	Color colorPrimary;
	Color colorSecondary;
	// MNotSaved
	Color colorPrimaryLerpTo;
	// MNotSaved
	Color colorSecondaryLerpTo;
	float32 start;
	float32 end;
	float32 farz;
	float32 maxdensity;
	float32 exponent;
	float32 HDRColorScale;
	// MNotSaved
	float32 skyboxFogFactor;
	// MNotSaved
	float32 skyboxFogFactorLerpTo;
	// MNotSaved
	float32 startLerpTo;
	// MNotSaved
	float32 endLerpTo;
	// MNotSaved
	float32 maxdensityLerpTo;
	// MNotSaved
	GameTime_t lerptime;
	float32 duration;
	float32 blendtobackground;
	float32 scattering;
	float32 locallightscale; // = 1
	bool enable;
	bool blend;
	// MNotSaved
	bool m_bPadding2;
	// MNotSaved
	bool m_bPadding;
};
