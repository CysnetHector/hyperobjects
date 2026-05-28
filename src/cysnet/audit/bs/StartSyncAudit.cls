Class cysnet.audit.bs.StartSyncAudit Extends Ens.BusinessService
{

Parameter BPROCESS = "SyncAudit";

Parameter ADAPTER = "Ens.InboundAdapter";

Property MaxItems As %Integer [ InitialExpression = 10 ];

Parameter SETTINGS = "MaxItems";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#dim rsp as cysnet.audit.msg.SyncAuditResponse
	set req = ##class(cysnet.audit.msg.SyncAuditRequest).%New()
	set req.maxitems = ..MaxItems
	set sc = ..SendRequestSync(..#BPROCESS, req, .rsp)
	quit sc
}

}
