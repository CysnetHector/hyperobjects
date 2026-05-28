Include Ensemble

Class cysnet.rest.util.Util Extends %RegisteredObject
{

/// Método que convierte un query string en JSON y lo codifica correctamente
ClassMethod convertQueryString(json As %String) As %String
{
    #dim lista As %List
    #dim i As %Integer
    
    // Si no es un JSON, convertirlo:
    if ( ($f(json,"=") '= 0)&&($f(json,"{") = 0) ) {
        set json = $Replace(json,"=",""":""")
        set json = $Replace(json,"&",""",""")
        set json = "{"""_json_"""}"
    }
    
	set json = $ZCONVERT(json,"I","URL")
    set json = $ZCONVERT(json,"I","UTF8")
    
    set lista = $lfs(json,"\")
    for i=2:1:$ll(lista) {
        if ($Length($li(lista,i)) = 5) {
            set $li(lista,i) = $li(lista,i)_"\\"
        } elseif ($length($li(lista,i)) > 5) {
            set $li(lista,i) = $Extract($li(lista,i),1,5)_"\\"_$Extract($li(lista,i),6,$l($li(lista,i)))
        }
    }
    
    set json = $lts(lista,"\")
    set json = $ZCONVERT(json,"I","JS")
    set json = $Replace(json,"\","")
	// Corregir booleanos
	set json = $Replace(json,"""true""","true")
	set json = $Replace(json,"""false""","false")
    
    quit json
}

/// Método que codifica un GlobalCharacterStream correctamente
ClassMethod convertInput(input As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
{
	#dim newInput As %Stream.GlobalCharacter = ##class(%Stream.GlobalCharacter).%New()
	#dim lineaOri, linea As %String = ""
	
	do input.Rewind()
	while ('input.AtEnd) {
		set lineaOri = input.Read()
		set linea = $ZCONVERT(lineaOri,"L")
		
		do newInput.Write(..codificar(lineaOri))
  	}
  	
  	do newInput.Rewind()
  	
  	quit newInput
}

ClassMethod codificar(val As %String) As %String
{
	#dim valor As %String = ""
	
	set valor = $ZCONVERT(val,"L")
	
	if ( 
		($f(valor,"!") > 0)||($f(valor,"""") > 0)||($f(valor,"#") > 0)||($f(valor,"$") > 0)||($f(valor,"%") > 0)||
		($f(valor,"&") > 0)||($f(valor,"'") > 0)||($f(valor,"(") > 0)||($f(valor,")") > 0)||($f(valor,"*") > 0)||
		($f(valor,"+") > 0)||($f(valor,",") > 0)||($f(valor,"-") > 0)||($f(valor,")") > 0)||($f(valor,"*") > 0)||
		
		($f(valor,"¡") > 0)||($f(valor,"¢") > 0)||($f(valor,"£") > 0)||($f(valor,"¤") > 0)||($f(valor,"¥") > 0)||
		($f(valor,"¦") > 0)||($f(valor,"§") > 0)||($f(valor,"¨") > 0)||($f(valor,"©") > 0)||($f(valor,"ª") > 0)||
		($f(valor,"«") > 0)||($f(valor,"¬") > 0)||($f(valor,"®") > 0)||($f(valor,"¯") > 0)||
		($f(valor,"°") > 0)||($f(valor,"±") > 0)||($f(valor,"²") > 0)||($f(valor,"³") > 0)||($f(valor,"´") > 0)||
		($f(valor,"µ") > 0)||($f(valor,"¶") > 0)||($f(valor,"·") > 0)||($f(valor,"¸") > 0)||($f(valor,"¹") > 0)||
		($f(valor,"º") > 0)||($f(valor,"»") > 0)||($f(valor,"¼") > 0)||($f(valor,"½") > 0)||($f(valor,"¾") > 0)||
		($f(valor,"¿") > 0)||($f(valor,"Æ") > 0)||($f(valor,"Ð") > 0)||($f(valor,"×") > 0)||($f(valor,"ß") > 0)||
		
		($f(valor,"à") > 0)||($f(valor,"á") > 0)||($f(valor,"â") > 0)||($f(valor,"ã") > 0)||($f(valor,"ä") > 0)||
		($f(valor,"å") > 0)||($f(valor,"æ") > 0)||($f(valor,"ç") > 0)||
		($f(valor,"è") > 0)||($f(valor,"é") > 0)||($f(valor,"ê") > 0)||($f(valor,"ë") > 0)||
		($f(valor,"ì") > 0)||($f(valor,"í") > 0)||($f(valor,"î") > 0)||($f(valor,"ï") > 0)||
		($f(valor,"ð") > 0)||($f(valor,"ñ") > 0)||
		($f(valor,"ò") > 0)||($f(valor,"ó") > 0)||($f(valor,"ô") > 0)||($f(valor,"õ") > 0)||($f(valor,"ö") > 0)||
		($f(valor,"÷") > 0)||($f(valor,"ø") > 0)||
		($f(valor,"ù") > 0)||($f(valor,"ú") > 0)||($f(valor,"û") > 0)||($f(valor,"ü") > 0)||
		($f(valor,"ý") > 0)||($f(valor,"þ") > 0)||($f(valor,"ÿ") > 0)||
		
		($f(valor,"ł") > 0)||($f(valor,"ę") > 0)||
		
		($f(valor,"œ") > 0)||($f(valor,"š") > 0)||($f(valor,"ÿ") > 0)||($f(valor,"ƒ") > 0)||
		
		($f(valor,"–") > 0)||($f(valor,"—") > 0)||($f(valor,"‘") > 0)||($f(valor,"’") > 0)||($f(valor,"‚") > 0)||
		($f(valor,"“") > 0)||($f(valor,"”") > 0)||($f(valor,"„") > 0)||($f(valor,"†") > 0)||($f(valor,"‡") > 0)||
		($f(valor,"•") > 0)||($f(valor,"…") > 0)||($f(valor,"‰") > 0)||($f(valor,"€") > 0)||($f(valor,"™") > 0)||
		
		($f(valor,"@") > 0)||($f(valor,"'") > 0)||($f(valor,"´") > 0)||($f(valor,"¨") > 0)||($f(valor,"`") > 0)
	) {
		set valor = val
	} else {
		set valor = $ZCONVERT(val,"I","UTF8")
	}
	
	quit valor
}

}
