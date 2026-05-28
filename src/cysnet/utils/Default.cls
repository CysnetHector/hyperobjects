Class cysnet.utils.Default Extends %RegisteredObject
{

ClassMethod insertDefault() As %Status
{
	#dim sc As %Status = $$$OK
	
	w "INICIO: "_$ZDT($H,3),!

	try {
		k ^cysnet.alcACDC.MapeoRegist9E22D
		k ^cysnet.alcACDC.MapeoRegist9E22I

		k ^cysnet.syncEn216D.MapeoEntidadD
		k ^cysnet.syncEn216D.MapeoEntidadI

		k ^cysnet.syncEngine216D.EntidadD
		k ^cysnet.syncEngine216D.EntidadI

		k ^cysnet.syncEngine216D.ConectorD
		k ^cysnet.syncEngine216D.ConectorI

		k ^cysnet.syncEngin216D.HL7ConfigD
		k ^cysnet.syncEngin216D.HL7ConfigI
		
		w "Insertando entidades...",!!
		do ..execute(1, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('Organization', 1, 1)")
		do ..execute(2, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('Practitioner', 1, 1)")
		do ..execute(3, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('PractitionerRole', 1, 1)")
		do ..execute(4, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('Patient', 1, 1)")
		do ..execute(5, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('RelatedPerson', 1, 1)")
		do ..execute(6, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('Encounter', 1, 1)")
		do ..execute(7, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('Appointment', 1, 1)")
		do ..execute(8, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('ServiceRequest', 1, 1)")
		do ..execute(9, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('Specimen', 1, 1)")
		do ..execute(10, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('Observation', 1, 1)")
		do ..execute(11, "INSERT INTO cysnet_syncEngine_core_data.Entidad (nombre, bidireccional, activo) VALUES ('Procedure', 1, 1)")

		w !!,"Insertando conectores...",!
		do ..insertConectores()

		w !!,"Insertando mapeos entidades...",!
		do ..insertMapeosEntidades()

		
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		w $System.Status.GetErrorText(sc)
	}

	w "FIN: "_$ZDT($H,3),!

	quit $$$OK
}

ClassMethod insertConectores() As %Status
{
	#dim sc As %Status = $$$OK

	w "--> Inicio insertConectores: "_$ZDT($H,3),!

	try {
		do ..execute(1, "INSERT INTO cysnet_syncEngine_core_data.Conector (nombre, descripcion, paquete, proceso, abreviatura) "_
						"VALUES ('HyperObjects', 'Conector con HyperObjects', 'hyperobjects', 'SyncHyperObjects', 'HO')")
		
		do ..execute(4, "INSERT INTO cysnet_syncEngine_core_data.Conector (nombre, descripcion, paquete, proceso, abreviatura, activo) "_
						"VALUES ('OpenEMR', 'Conector con OpenEMR, para actualizar contenido', 'openEmr', 'SyncOpenEMR', 'OpenEMR', 1)")

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		w $System.Status.GetErrorText(sc)
	}

	w "--> Fin insertConectores: "_$ZDT($H,3),!

	quit $$$OK
}

ClassMethod insertMapeosEntidades() As %Status
{
	#dim sc As %Status = $$$OK
	
	w "--> Inicio insertMapeosEntidades: "_$ZDT($H,3),!

	try {
		set idEMR = $Order(^cysnet.syncEngine216D.ConectorI("paqueteIdx","OpenEMR",""),1)

		if (idEMR '= "") {
			// OpenEMR -> Organization
			do ..execute("OpenEMR-"_1, "INSERT INTO cysnet_syncEngine_core_data.MapeoEntidad (conector, entidad, entidadOri, clave, activo) VALUES ("_idEMR_", 1, 'facility', 'uuid', 1)")
			// OpenEMR -> Practitioner
			do ..execute("OpenEMR-"_2, "INSERT INTO cysnet_syncEngine_core_data.MapeoEntidad (conector, entidad, entidadOri, clave, activo) VALUES ("_idEMR_", 2, 'practitioner', 'uuid', 1)")
			// OpenEMR -> PractitionerRole
			do ..execute("OpenEMR-"_3, "INSERT INTO cysnet_syncEngine_core_data.MapeoEntidad (conector, entidad, entidadOri, clave, activo) VALUES ("_idEMR_", 3, 'practitioner', 'uuid', 1)")
			// OpenEMR -> Patient
			do ..execute("OpenEMR-"_4, "INSERT INTO cysnet_syncEngine_core_data.MapeoEntidad (conector, entidad, entidadOri, clave, campoLastUpdate, activo) VALUES ("_idEMR_", 4, 'patient', 'uuid', 'date', 1)")
			// OpenEMR -> RelatedPerson
			do ..execute("OpenEMR-"_5, "INSERT INTO cysnet_syncEngine_core_data.MapeoEntidad (conector, entidad, entidadOri, clave, campoLastUpdate, filtro, activo) VALUES ("_idEMR_", 5, 'patient', 'uuid', 'date', '""guardiansname"" ''= """"', 1)")
			// OpenEMR -> Encounter
			do ..execute("OpenEMR-"_6, "INSERT INTO cysnet_syncEngine_core_data.MapeoEntidad (conector, entidad, entidadOri, clave, campoLastUpdate, entidadDepende, claveDepende, activo) VALUES ("_idEMR_", 6, 'encounter', 'euuid', 'last_update', 4, 'uuid', 1)")
			// OpenEMR -> Appointment
			do ..execute("OpenEMR-"_7, "INSERT INTO cysnet_syncEngine_core_data.MapeoEntidad (conector, entidad, entidadOri, clave, entidadDepende, claveDepende, activo, accionesPermitidas) VALUES ("_idEMR_", 7, 'appointment', 'pc_eid', 4, 'pid', 1, 'I')")
		}

		
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		w $System.Status.GetErrorText(sc)
	}

	w "--> Fin insertMapeosEntidades: "_$ZDT($H,3),!

	quit $$$OK
}

ClassMethod execute(numSQL As %String, sql As %String)
{
	set stm = ##class(%SQL.Statement).%New()
    do stm.%Prepare(sql)
    set rs = stm.%Execute()
	if (rs.%SQLCODE '= 0) {
		w "**********************************************",!
		w "**** ERROR "_numSQL_" **** "_$System.SQL.Functions.SQLCODE(rs.%SQLCODE),!
		w "**********************************************",!!
	}
}

ClassMethod crearGloblalDefaultAuditoria() As %Status
{
	#dim sc as %Status = $$$OK

	;Crear global y asignar valores por defecto
	set ^cysnet.audit.config("enabled") = 0
	set ^cysnet.audit.config("API","REST") = 1
	set ^cysnet.audit.config("DTL") = 1
	set ^cysnet.audit.config("HL7") = 1
	set ^cysnet.audit.config("API","REST","IncludeHeaders") = 1	
	set ^cysnet.audit.config("API","REST","GET") = 1	
	set ^cysnet.audit.config("API", "REST", "GET", "IncludeRequest") = 1
	set ^cysnet.audit.config("API", "REST", "GET", "IncludeResponse") = 1
	merge ^cysnet.audit.config("API", "REST", "POST") = ^cysnet.audit.config("API", "REST", "GET")
	merge ^cysnet.audit.config("API", "REST", "PUT") = ^cysnet.audit.config("API", "REST", "GET") 
	merge ^cysnet.audit.config("API", "REST", "DELETE") = ^cysnet.audit.config("API", "REST", "GET")
	merge ^cysnet.audit.config("API", "SOAP") = ^cysnet.audit.config("API", "REST", "GET")	
	merge ^cysnet.audit.config("API", "SOAP","IncludeHeaders") = ^cysnet.audit.config("API", "REST","IncludeHeaders")	
	set ^cysnet.audit.config("HL7", "IN") = 1
	set ^cysnet.audit.config("HL7", "IN", "IncludeContent") = 1
	set ^cysnet.audit.config("HL7", "OUT") = 1
	set ^cysnet.audit.config("HL7", "OUT", "IncludeContent") = 1

	quit sc
}

}
