// MHasKV3TransferPolymorphicClassname
class CParticleSystemDefinition : public IParticleSystemDefinition
{
	// MPropertyFriendlyName = "version"
	// MPropertySuppressField
	int32 m_nBehaviorVersion;
	// MPropertySuppressField
	CUtlVector< CParticleFunctionPreEmission* > m_PreEmissionOperators;
	// MPropertySuppressField
	CUtlVector< CParticleFunctionEmitter* > m_Emitters;
	// MPropertySuppressField
	CUtlVector< CParticleFunctionInitializer* > m_Initializers;
	// MPropertySuppressField
	CUtlVector< CParticleFunctionOperator* > m_Operators;
	// MPropertySuppressField
	CUtlVector< CParticleFunctionForce* > m_ForceGenerators;
	// MPropertySuppressField
	CUtlVector< CParticleFunctionConstraint* > m_Constraints;
	// MPropertySuppressField
	CUtlVector< CParticleFunctionRenderer* > m_Renderers;
	// MPropertySuppressField
	CUtlVector< ParticleChildrenInfo_t > m_Children;
	// MPropertySuppressField
	int32 m_nFirstMultipleOverride_BackwardCompat; // = -1
	// MPropertyStartGroup = "+Collection Options"
	// MPropertyFriendlyName = "initial particles"
	int32 m_nInitialParticles;
	// MPropertyFriendlyName = "max particles"
	int32 m_nMaxParticles; // = 1000
	// MPropertyFriendlyName = "group id"
	int32 m_nGroupID;
	// MPropertyStartGroup = "Bounding Box"
	// MPropertyFriendlyName = "bounding box bloat min"
	// MVectorIsCoordinate
	Vector m_BoundingBoxMin; // = [ -10, -10, -10 ]
	// MPropertyFriendlyName = "bounding box bloat max"
	// MVectorIsCoordinate
	Vector m_BoundingBoxMax; // = [ 10, 10, 10 ]
	// MPropertyFriendlyName = "bounding box depth sort bias"
	float32 m_flDepthSortBias;
	// MPropertyFriendlyName = "sort override position CP"
	int32 m_nSortOverridePositionCP; // = -1
	// MPropertyFriendlyName = "infinite bounds - don't cull"
	bool m_bInfiniteBounds;
	// MPropertyStartGroup = "Named Values"
	// MPropertyFriendlyName = "Enable Named Values (EXPERIMENTAL)"
	bool m_bEnableNamedValues;
	// MPropertyFriendlyName = "Domain Class"
	// MPropertyAttributeChoiceName = "particlefield_domain"
	// MPropertyAutoRebuildOnChange
	// MPropertySuppressExpr = "!m_bEnableNamedValues"
	CUtlString m_NamedValueDomain;
	// MPropertySuppressField
	CUtlVector< ParticleNamedValueSource_t* > m_NamedValueLocals;
	// MPropertyStartGroup = "+Base Properties"
	// MPropertyFriendlyName = "color"
	// MPropertyColorPlusAlpha
	Color m_ConstantColor; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "normal"
	// MVectorIsCoordinate
	Vector m_ConstantNormal; // = [ 0, 0, 1 ]
	// MPropertyFriendlyName = "radius"
	// MPropertyAttributeRange = "biased 0 500"
	float32 m_flConstantRadius; // = 5
	// MPropertyFriendlyName = "rotation"
	float32 m_flConstantRotation;
	// MPropertyFriendlyName = "rotation speed"
	float32 m_flConstantRotationSpeed;
	// MPropertyFriendlyName = "lifetime"
	float32 m_flConstantLifespan; // = 1
	// MPropertyFriendlyName = "sequence number"
	// MPropertyAttributeEditor = "SequencePicker( 1 )"
	int32 m_nConstantSequenceNumber;
	// MPropertyFriendlyName = "sequence number 1"
	// MPropertyAttributeEditor = "SequencePicker( 2 )"
	int32 m_nConstantSequenceNumber1;
	// MPropertyStartGroup = "Snapshot Options"
	int32 m_nSnapshotControlPoint;
	CStrongHandle< InfoForResourceTypeIParticleSnapshot > m_hSnapshot;
	// MPropertyStartGroup = "Replacement Options"
	// MPropertyFriendlyName = "cull replacement definition"
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_pszCullReplacementName;
	// MPropertyFriendlyName = "cull radius"
	float32 m_flCullRadius;
	// MPropertyFriendlyName = "cull cost"
	float32 m_flCullFillCost; // = 1
	// MPropertyFriendlyName = "cull control point"
	int32 m_nCullControlPoint;
	// MPropertyFriendlyName = "fallback replacement definition"
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_hFallback;
	// MPropertyFriendlyName = "fallback max count"
	int32 m_nFallbackMaxCount; // = -1
	// MPropertyFriendlyName = "low violence definition"
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_hLowViolenceDef;
	// MPropertyFriendlyName = "reference replacement definition"
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_hReferenceReplacement;
	// MPropertyStartGroup = "Simulation Options"
	// MPropertyFriendlyName = "pre-simulation time"
	float32 m_flPreSimulationTime;
	// MPropertyFriendlyName = "freeze simulation after time"
	float32 m_flStopSimulationAfterTime; // = 1000000000
	// MPropertyFriendlyName = "maximum time step"
	float32 m_flMaximumTimeStep; // = 0.1
	// MPropertyFriendlyName = "maximum sim tick rate"
	float32 m_flMaximumSimTime;
	// MPropertyFriendlyName = "minimum sim tick rate"
	float32 m_flMinimumSimTime;
	// MPropertyFriendlyName = "minimum simulation time step"
	float32 m_flMinimumTimeStep;
	// MPropertyFriendlyName = "minimum required rendered frames"
	int32 m_nMinimumFrames;
	// MPropertyFriendlyName = "simulated on the GPU"
	// MPropertySuppressExpr = "mod != hlx"
	// MPropertyAutoRebuildOnChange
	bool m_bIsGPUParticleSystem;
	// MPropertyStartGroup = "Performance Options"
	// MPropertyFriendlyName = "minimum CPU level"
	int32 m_nMinCPULevel;
	// MPropertyFriendlyName = "minimum GPU level"
	int32 m_nMinGPULevel;
	// MPropertyFriendlyName = "time to sleep when not drawn"
	float32 m_flNoDrawTimeToGoToSleep; // = 8
	// MPropertyFriendlyName = "maximum draw distance"
	float32 m_flMaxDrawDistance; // = -1
	// MPropertyFriendlyName = "start fade distance"
	float32 m_flStartFadeDistance; // = 200000
	// MPropertyFriendlyName = "maximum creation distance"
	float32 m_flMaxCreationDistance; // = -1
	// MPropertyFriendlyName = "minimum free particles to aggregate"
	int32 m_nAggregationMinAvailableParticles; // = 1
	// MPropertyFriendlyName = "aggregation radius"
	float32 m_flAggregateRadius;
	// MPropertyFriendlyName = "batch particle systems (DO NOT USE)"
	// MParticleAdvancedField
	bool m_bShouldBatch;
	// MPropertyFriendlyName = "Hitboxes fall back to render bounds"
	bool m_bShouldHitboxesFallbackToRenderBounds; // = true
	// MPropertyFriendlyName = "Hitboxes fall back to snapshot"
	bool m_bShouldHitboxesFallbackToSnapshot; // = true
	// MPropertyFriendlyName = "Hitboxes fall back to collision hulls"
	bool m_bShouldHitboxesFallbackToCollisionHulls; // = true
	// MPropertyStartGroup = "Rendering Options"
	// MPropertyFriendlyName = "view model effect"
	// MPropertySuppressExpr = "m_bScreenSpaceEffect"
	InheritableBoolType_t m_nViewModelEffect; // = "INHERITABLE_BOOL_INHERIT"
	// MPropertyFriendlyName = "screen space effect"
	// MPropertySuppressExpr = "m_nViewModelEffect == INHERITABLE_BOOL_TRUE"
	bool m_bScreenSpaceEffect;
	// MPropertyFriendlyName = "target layer ID for rendering"
	CUtlSymbolLarge m_pszTargetLayerID;
	// MPropertyFriendlyName = "control point to disable rendering if it is the camera"
	int32 m_nSkipRenderControlPoint; // = -1
	// MPropertyFriendlyName = "control point to only enable rendering if it is the camera"
	int32 m_nAllowRenderControlPoint; // = -1
	// MPropertyFriendlyName = "sort particles (DEPRECATED - USE RENDERER OPTION)"
	// MParticleAdvancedField
	bool m_bShouldSort; // = true
	// MPropertySuppressField
	CUtlVector< ParticleControlPointConfiguration_t > m_controlPointConfigurations;
};
