class inv_image_camera_t
{
	// MPropertyFriendlyName = "Angle"
	// MCustomFGDMetadata = "{ reset_to_default_icon = true }"
	QAngle angle;
	// MPropertyFriendlyName = "Horizontal FOV"
	// MCustomFGDMetadata = "{ reset_to_default_icon = true }"
	// MPropertyAttributeRange = "0 360"
	float32 fov_h;
	// MPropertyFriendlyName = "Vertical FOV"
	// MCustomFGDMetadata = "{ reset_to_default_icon = true }"
	// MPropertyAttributeRange = "0 360"
	float32 fov_v; // = 45
	// MPropertyFriendlyName = "Z Near"
	// MCustomFGDMetadata = "{ reset_to_default_icon = true }"
	// MPropertyAttributeRange = "0 1000"
	float32 znear; // = 4
	// MPropertyFriendlyName = "Z Far"
	// MCustomFGDMetadata = "{ reset_to_default_icon = true }"
	// MPropertyAttributeRange = "0 1000"
	float32 zfar; // = 1000
	// MPropertyFriendlyName = "Target"
	// MCustomFGDMetadata = "{ reset_to_default_icon = true }"
	Vector target;
	// MPropertyFriendlyName = "Target Nudge"
	// MCustomFGDMetadata = "{ reset_to_default_icon = true }"
	Vector target_nudge;
	// MPropertyFriendlyName = "Orbit Distance"
	// MCustomFGDMetadata = "{ reset_to_default_icon = true }"
	// MPropertyAttributeRange = "0 1000"
	float32 orbit_distance;
};
