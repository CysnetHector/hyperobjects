ROUTINE cysnet.rest.util.JsonRoutine [Type=INC]

#include Ensemble

#define ZENJSONVALUENEW(%val,%format)		$S($$$ZENJSISNUM(%val):$$$ZENJSNUM(%val),("true"=%val)||("false"=%val):(%val),$C(0)=(%val):"null",$ListValid(%val):"""""",1:$$$ZENJSONSTR(%val,%format))
#define ZENJSONPAIRNEW(%pr,%val,%format)	$$$ZENJSONPROP(%pr,%format)_":"_$$$ZENJSONVALUENEW(%val,%format)