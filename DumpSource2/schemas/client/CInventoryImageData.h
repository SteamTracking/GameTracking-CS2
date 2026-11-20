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
	inv_image_data_t inventory_image_data;
};
