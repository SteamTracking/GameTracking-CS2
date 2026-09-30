class inv_image_data_t
{
	// MPropertyFriendlyName = "Map"
	// MPropertyAutoExpandSelf
	inv_image_map_t map; // = { "map_name": "ui/icon_generation_basic_nuke_bombsitea", "map_rotation": 0 }
	// MPropertyFriendlyName = "Item"
	// MPropertyAutoExpandSelf
	inv_image_item_t item;
	// MPropertyFriendlyName = "Camera"
	// MPropertyAutoExpandSelf
	inv_image_camera_t camera; // = { "angle": [ 0, 0, 0 ], "fov_h": 0, "fov_v": 45, "orbit_distance": 0, "target": [ 0, 0, 0 ], "target_nudge": [ 0, 0, 0 ], "zfar": 1000, "znear": 4 }
	// MPropertyFriendlyName = "Sun light"
	// MPropertyDescription = "Shadowed."
	// MPropertyAutoExpandSelf
	inv_image_light_sun_t lightsun; // = { "angle": [ 0, 0, 0 ], "brightness": 1, "color": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "Fill light"
	// MPropertyDescription = "No Shadows."
	// MPropertyAutoExpandSelf
	inv_image_light_fill_t lightfill; // = { "angle": [ 0, 0, 0 ], "brightness": 1, "color": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "Barn light 0"
	// MPropertyDescription = "Shadowed."
	// MPropertyAutoExpandSelf
	inv_image_light_barn_t light0; // = { "angle": [ 0, 0, 0 ], "brightness": 0, "color": [ 0, 0, 0 ], "orbit_distance": 1 }
	// MPropertyFriendlyName = "Barn light 1"
	// MPropertyDescription = "Shadowed."
	// MPropertyAutoExpandSelf
	inv_image_light_barn_t light1; // = { "angle": [ 0, 0, 0 ], "brightness": 0, "color": [ 0, 0, 0 ], "orbit_distance": 1 }
	// MPropertyFriendlyName = "Clear Color"
	// MPropertyDescription = ""
	// MPropertyAutoExpandSelf
	inv_image_clearcolor_t clearcolor; // = { "color": [ 0.2, 0.2, 0.2 ] }
};
