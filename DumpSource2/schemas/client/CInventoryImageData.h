// MVDataRoot
// MVDataOutlinerDetailExpr = "name"
// MVDataOverlayType = 1
// MVDataPreviewWidget = "csgo_inv_image_preview"
// MVDataHideNodeClass
// MVDataOutlinerLeafNameFn
// MVDataOutlinerLeafColorFn
// MVDataOutlinerLeafDetailFn
// MVDataVirtualNodeFactoryFn
// MVDataPreLoadFixupFn
// MVDataPostSaveFixupFn
class CInventoryImageData
{
	// MPropertySuppressField
	InventoryNodeType_t m_nNodeType; // = "NODE_TYPE_INVALID"
	// MPropertyFriendlyName = "Item Name"
	// MPropertyReadOnly
	// MPropertyReadonlyExpr = "1"
	// MPropertySuppressExpr = "name == """
	CUtlString name;
	// MPropertyFriendlyName = "Inventory Image Data"
	// MPropertyAutoExpandSelf
	inv_image_data_t inventory_image_data; // = { "camera": { "angle": [ 0, 0, 0 ], "fov_h": 0, "fov_v": 45, "orbit_distance": 0, "target": [ 0, 0, 0 ], "target_nudge": [ 0, 0, 0 ], "zfar": 1000, "znear": 4 }, "clearcolor": { "color": [ 0.2, 0.2, 0.2 ] }, "item": { "angle": [ 0, 0, 0 ], "pose_sequence": "", "position": [ 0, 0, 0 ] }, "light0": { "angle": [ 0, 0, 0 ], "brightness": 0, "color": [ 0, 0, 0 ], "orbit_distance": 1 }, "light1": { "angle": [ 0, 0, 0 ], "brightness": 0, "color": [ 0, 0, 0 ], "orbit_distance": 1 }, "lightfill": { "angle": [ 0, 0, 0 ], "brightness": 1, "color": [ 0, 0, 0 ] }, "lightsun": { "angle": [ 0, 0, 0 ], "brightness": 1, "color": [ 0, 0, 0 ] }, "map": { "map_name": "ui/icon_generation_basic_nuke_bombsitea", "map_rotation": 0 } }
};
