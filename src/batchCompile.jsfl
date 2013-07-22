// File named "batchCompile.jsfl"
//    USAGE : Simply double-click the file icon in your explorer window.
//                If you have the Flash IDE, it will run this script as a command.

fl.trace("Batch Publish");
var proceed = true;

// Enviornment variables.///////////////////////////
////////////////////////////////////////////////////

// the drive on which the project lives.
//var drive = "/Users/";

// user's windows environment.
// Replace "MY_USERNAME" with your username


// path from windows enviornment to the flas.
var projectLocation = "file:///Users/jameskong/Development/ActionScript3/VirtualFitting/src/";



// log file...
var logURI = "";
var errorsURI = "";

//////////////////////////////////////////////////
//////////////////////////////////////////////////

if(proceed){

	var success = true;

	// eg : path == "Documents and Settings/theHorseman/My Documents/scriptocalypse/source"	
	var path =   projectLocation;


	var files = [
	"gamecore.fla",
	"selectcover.fla",
	"category.fla",
	"instruction.fla",
	"solution.fla",
	"category_list_item.fla",
	"song_list_item.fla",
	"circle.fla",
	"landing.fla",
	"songlist.fla",
	"confirmcover.fla",
	"landingbutton.fla",
	"startbutton.fla",
	"countdown1.fla",
	"player.fla",
	"wave.fla",
	"countdown2.fla",
	"postfacebook.fla",
	"flashing.fla",
	"keyboard.fla",
	"coverflow.fla"
	];
	fl.trace("Proceeding");
	var i = 0;
	var ilen = files.length;

	var successLog = "";

	// external logs...
	logURI = path+"batchPublishLog.txt";
	errorsURI = path+"errors.txt";

	createLog();
	createErrorCheck();
	//////////////////

	for(i = 0 ; i < ilen ; i++){
		var fileURI;
		var exists;

		exists = FLfile.exists(path);
		if(!exists){
			//alert("Failed to find "+path);
			success = false;
			break;
		}




		fileURI = path+files[i];
		fl.trace(fileURI);
		exists = FLfile.exists(fileURI);
		var DOM;
		var publishSuccess;
		fl.trace(files[i]+" exists : "+exists+"\n");
		if(exists){
			fl.openDocument(fileURI);
			DOM = fl.getDocumentDOM();
			publishSuccess = publish(DOM, logURI);
			fl.trace(publishSuccess)
			if(!publishSuccess){
				//alert("Failed to publish "+files[i]+"!");
				fl.trace("Failed to publish "+files[i]+"!\n  Checking the errors.txt log for more details...\n\n"+FLfile.read(errorsURI)+"\n-------------------------------------------------------------------\n");
				success = false;
				//break;
			}
			successLog += ("published : "+files[i]+"\n");
			//DOM.close();

		}else{
			//alert("Failed to open "+files[i]+"!");
			fl.trace("The file '"+fileURI+"' does not exist!\n");
			success = false;
			//break;
		}

	}

	if(success){
		fl.trace("----------------------\n------ Results -------\n----------------------\n");
		fl.trace(successLog);		
		fl.trace("-------------------------\n--- Publish Succeeded ---\n-------------------------");
		//alert("Batch Publish Succeeded!");
	}else{
		fl.trace("----------------------\n------ Results -------\n----------------------\n");
		fl.trace(successLog);
		fl.trace("FAILED AT : "+files[i]+"!");
		fl.trace("\n----------------------\n--- PUBLISH FAILED ---\n----------------------");
		//alert("BATCH PUBLISH FAILED!");
	}
}

function publish(DOM, logURI){
	var success = true;
	if(DOM){
		DOM.publish();
		log(DOM.docClass+" results :\n\t");
		fl.outputPanel.save(logURI,true);
		fl.compilerErrors.save(logURI,true);
		logCompileErrors();
		log("\n");
	}else{
		success = false;
	}

	// found any compile errors?
	if(FLfile.read(errorsURI) != ""){		
		success = false;
	}

	return success;
}

function createErrorCheck(){
	FLfile.write(errorsURI, "");
}
function logCompileErrors(){
	fl.compilerErrors.save(errorsURI);
}

function createLog(){
	FLfile.write(logURI, "Compile Log...\n");
}

function log(message){
	FLfile.write(logURI, message, "append");
}