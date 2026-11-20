class inv_image_data_t
{
	// MPropertyFriendlyName = "Map"
	// MPropertyAutoExpandSelf
	inv_image_map_t map;
	// MPropertyFriendlyName = "Item"
	// MPropertyAutoExpandSelf
	inv_image_item_t item;
	// MPropertyFriendlyName = "Camera"
	// MPropertyAutoExpandSelf
	inv_image_camera_t camera;
	// MPropertyFriendlyName = "Sun light"
	// MPropertyDescription = "Shadowed."
	// MPropertyAutoExpandSelf
	inv_image_light_sun_t lightsun;
	// MPropertyFriendlyName = "Fill light"
	// MPropertyDescription = "No Shadows."
	// MPropertyAutoExpandSelf
	inv_image_light_fill_t lightfill;
	// MPropertyFriendlyName = "Barn light 0"
	// MPropertyDescription = "Shadowed."
	// MPropertyAutoExpandSelf
	inv_image_light_barn_t light0;
	// MPropertyFriendlyName = "Barn light 1"
	// MPropertyDescription = "Shadowed."
	// MPropertyAutoExpandSelf
	inv_image_light_barn_t light1;
	// MPropertyFriendlyName = "Clear Color"
	// MPropertyDescription = ""
	// MPropertyAutoExpandSelf
	inv_image_clearcolor_t clearcolor;
};
