class CFuseSymbolTable
{
	CUtlVector< ConstantInfo_t > m_constants;
	CUtlVector< VariableInfo_t > m_variables;
	CUtlVector< FunctionInfo_t > m_functions;
	CUtlHashtable< CUtlStringToken, int32 > m_constantMap;
	CUtlHashtable< CUtlStringToken, int32 > m_variableMap;
	CUtlHashtable< CUtlStringToken, int32 > m_functionMap;
};
