//http://www.websitecodetutorials.com/code/javascript/javascript-format-phone-number.php


function formatPhoneStr(A){
	var C=A.replace(/[^0-9xX]/g,"");
	C=C.replace(/[xX]/g,"x");
	var B="";
	if(C.indexOf("x")>-1){
		B=" "+C.substr(C.indexOf("x"));
		C=C.substr(0,C.indexOf("x"))
	}
	
	switch(C.length){
        case 7:
            return C.replace(/(...)(....)/g,"$1-$3")+B;
            break;
		case (10):
			return C.replace(/(...)(...)(....)/g,"($1) $2-$3")+B;
		case (11):
			if(C.substr(0,1)=="1"){
				return C.substr(1).replace(/(...)(...)(....)/g,"+1 ($1) $2-$3")+B
			}
			break;
		default:
			break;
		}
	return A;
}
		

$(document).ready(function () {

    $(".telephone").on( "blur", function(event)
    {
        var A = event;
        A.value=formatPhoneStr(A.value);
    })
});