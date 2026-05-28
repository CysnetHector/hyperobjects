Include Ensemble

Class cysnet.rest.proxy.Interface Extends %RegisteredObject [ Abstract ]
{

Method getRequest() As %RegisteredObject [ Abstract ]
{
	Quit $$$EnsError($$$NotImplemented)
}

Method getResponse(pProxyResponse As %AbstractStream) As %Status [ Abstract ]
{
	Quit $$$EnsError($$$NotImplemented)
}

}
