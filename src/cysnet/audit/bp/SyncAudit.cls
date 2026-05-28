Class cysnet.audit.bp.SyncAudit Extends Ens.BusinessProcess
{

Parameter BOPERATION = "AuditLog";

Method OnRequest(pRequest As cysnet.audit.msg.SyncAuditRequest, Output pResponse As cysnet.audit.msg.SyncAuditResponse) As %Status
{
	// Creamos la respuesta para devolverla cuando corresponda
	set pResponse = ##class(cysnet.audit.msg.SyncAuditResponse).%New()
	set pResponse.done = 0

	// Obtenemos el número de registros del global que deben procesarse
	set maxitems = pRequest.maxitems

	// Obtenemos el global donde se almacenan los registros.
	set grecords = ##class(cysnet.audit.util.AuditRecord).#GLAUDITRECORDS

	// Si no hay elementos en el global o no existe el global, salimos.
	if ('##class(cysnet.utils.HelperGlobals).existsGlobal(grecords))
	{
		quit $$$OK
	}

	// Intentamos extraer del Global (maxitems)
	while (maxitems>0)
	{
		// Obtenemos el indice de la primera entrada del global
		set gindex = ##class(cysnet.utils.HelperGlobals).getFirstIndex(grecords)
		
		if (gindex'="")
		{
			// Obtenemos el primer elemento, que es un JSON de auditoria
			set jsonAuditoria = ##class(cysnet.utils.HelperGlobals).getGlobalValue(grecords,gindex)
			// Lo intentamos insertar a través del BusinessOperation
			set reqAudit = ##class(cysnet.audit.msg.AddAuditRecordRequest).%New()
			#dim rspAudit as cysnet.audit.msg.AddAuditRecordResponse			
			set reqAudit.jsonAudit = ##class(%Stream.GlobalCharacter).%New()
			do reqAudit.jsonAudit.Write(jsonAuditoria)

			// Invocamos la BusinessOperation
			set sc = ..SendRequestSync(..#BOPERATION,reqAudit,.rspAudit)
			
			// Si se ha realizado correctamente, eliminamos el registro del global
			if ($$$ISOK(sc)) {
				//Comprobamos que efectivamente se ha realizado el traspaso del registro
				if (rspAudit.done){
					do ##class(cysnet.utils.HelperGlobals).removeGlobalValue(grecords,gindex)  
				}else{
					//¿Registrar error?
				}
 			} else {
				//¿Registrar error?
			}
			set maxitems = maxitems - 1
		}
		else
		{
			set maxitems = 0
		}
	}

	set pResponse.done = 1
	quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
