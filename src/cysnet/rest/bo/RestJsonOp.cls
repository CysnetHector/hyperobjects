Class cysnet.rest.bo.RestJsonOp Extends cysnet.rest.bo.RestManager
{

Method restMethod(pRequest As cysnet.rest.msg.RestRequest, Output pResponse As cysnet.rest.msg.RestResponse) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.rest.proxy.Rest
	
	set pResponse = ##class(cysnet.rest.msg.RestResponse).%New()
	
	if ($l(pRequest.proxyClass) > 1) {
		$$$LOGINFO("PROXYCLASS "_pRequest.proxyClass)
		set proxyManager = $ClassMethod(pRequest.proxyClass,"%New")
	} else {
		set proxyManager = ##class(cysnet.rest.proxy.Rest).%New()
	}
	
	set sc = ..runMethod(proxyManager, pRequest.input, pRequest.url, pRequest.method, pRequest.contentType, pRequest.headerParams, pRequest.params)
	if ($$$ISOK(sc)) {
		set pResponse = proxyManager.response
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("RestJsonOp", "Error en restMethod: "_$System.Status.GetErrorText(sc))
	}
	
	quit sc
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="cysnet.rest.msg.RestRequest"> 
		<Method>restMethod</Method>
	</MapItem>
</MapItems>
}

}
