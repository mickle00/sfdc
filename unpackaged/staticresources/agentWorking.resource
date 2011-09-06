// http://boards.developerforce.com/t5/Visualforce-Development/DatePicker-issue/td-p/271035
// Not override any existing SFDC onload

function addLoadEvent(func){ 
  var oldonload = window.onload; 
  if (typeof window.onload != 'function'){ 
     window.onload = func; 
  } 
  else{ 
      window.onload = function(){ 
        if (oldonload){ 
           oldonload(); 
        } 
        func(); 
      } 
   } 
}
function addUnLoadEvent(func){ 
  var oldonunload = window.onbeforeunload; 
  if (typeof window.onbeforeunload != 'function'){ 
     window.onbeforeunload = func; 
  } 
  else{ 
      window.onbeforeunload = function(){ 
        if (oldonunload){ 
           oldonunload(); 
        } 
        func(); 
      } 
   } 
} 
function loadPage(){
	startTime();
} 
function unloadPage(){
	stopTime();
}
addLoadEvent(loadPage); 
addUnLoadEvent(unloadPage);
