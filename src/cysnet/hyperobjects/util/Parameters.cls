Class cysnet.hyperobjects.util.Parameters Extends %RegisteredObject
{

Parameter COMPAREJSONMANDATORY = {$lb("resourceType","id","meta","identifier")};

Parameter COMPAREJSONIGNORE = {$lb("meta")};

Parameter COMPAREJSONLISTKEYS = {$lb("system","use")};

// Específico para Alchemit

Parameter COMPAREJSONMANDATORYALCHEMIT = {$lb("uuid","eid","euuid","pc_uuid","identificador","numero")};

// Específico para OpenEMR

Parameter COMPAREJSONMANDATORYOPENEMR = {$lb("uuid","eid","euuid","pc_uuid","pid","pc_eid")};

Parameter COMPAREJSONIGNOREOPENEMR = {$lb("date","period_start")};

// Globals

Parameter GLBPREFIX = "^cysnet.sync.";

Parameter GLBHYPEROBJECTS = "^cysnet.sync.HyperObjects";

Parameter GLBINFOHYPEROBJECTS = "^cysnet.sync.infoHyperObjects";

Parameter GLBALCHEMIT = "^cysnet.sync.infoAlchemit";

Parameter GLBOPENEMR = "^cysnet.sync.infoOpenEMR";

Parameter GLBSALESFORCE = "^cysnet.sync.infoSF";

Parameter GLBCAMBIOSINI = "^cysnet.sync.cambiosINI";

Parameter GLBCAMBIOSFIN = "^cysnet.sync.cambiosFIN";

Parameter GLBCAMBIOSREPROC = "^cysnet.sync.cambiosREPROC";

Parameter GLBOBJREPROC = "^cysnet.sync.objREPROC";

Parameter GLBCONECTOR = "^cysnet.syncEngine216D.ConectorI";

Parameter GLBINICIOFUSION = "^cysnet.sync.inicioFusion";

Parameter GLBPROCESOINIFUSION = "^cysnet.sync.ProcesoIniFusion";

Parameter GLBFINFUSION = "^cysnet.sync.finFusion";

}
