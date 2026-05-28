Include Ensemble

Class cysnet.openEmr.util.Util Extends cysnet.hyperobjects.util.Util
{

ClassMethod get(url As %String, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity, Output objID As %String = "", Output objOri As %DynamicObject) As %Status
{
	#dim sc As %Status = $$$OK
	#dim reqGet As cysnet.openEmr.msg.GetRequest
	#dim rspGet As cysnet.openEmr.msg.GetResponse

	try {
		set reqGet = ##class(cysnet.openEmr.msg.GetRequest).%New()
		set reqGet.url = url

		set sc = bp.SendRequestSync("OpenEMR", reqGet, .rspGet)

		if ($$$ISOK(sc)) {
			set pResponse.exito = rspGet.exito
			set pResponse.trace = rspGet.trace
			
			if (pResponse.exito = 1) {
				if ($IsObject(rspGet.resource))&&(rspGet.resource.content '= "") {
					set jsonOri = rspGet.resource.content
					set objOri = {}.%FromJSON(jsonOri)
				}
			}
		} else {
			set pResponse.exito = 0 // La traza se generará al final del proceso
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	quit sc
}

}
