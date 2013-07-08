package {	

	public class Utilities	{		private static var badWords:Array ;
				private static const charReplacements:Array = [["@", "a"], ["0", "o"], ["1", "i"], 
		  ["2", "r"], ["3", "e"], ["4", "a"], ["5", "s"], ["7", "t"], ["8", "b"], 
		  ["9", "g"], ["|<", "k"], ["|\/|", "m"], ["|\|", "n"], ["ä", "a"], ["ã", "a"], 
		  ["â", "a"], ["ä", "a"], ["á", "a"], ["à", "a"], ["å", "a"], ["é", "e"], 
		  ["è", "e"], ["ë", "e"], ["ê", "e"], ["§", "s"], ["$", "s"], ["£", "l"], 
		  ["€", "e"], ["ü", "u"], ["û", "u"], ["ú", "u"], ["ù", "u"], ["î", "i"], 
		  ["ï", "i"], ["í", "i"], ["ì", "i"], ["ÿ", "y"], ["ý", "y"], ["ö", "o"], 
		  ["ô", "o"], ["õ", "o"], ["ó", "o"], ["ò", "o"], ["(.)","boob"]];
		// Returns a profane word if found, else ""
		static public function addBadWord(_badWords:Array) {
			badWords = _badWords;
		}
		static public function checkName(text:String):String {
		  text = text.toLowerCase();
		  
		  for (var i:int = 0; i < charReplacements.length; i++ ) {
			var ra:Array = charReplacements[i] as Array;
			text = strReplace(text, ra[0], ra[1]);
		  }
		  trace(text);
		  for each (var w:Object in badWords) {
			/*if (text.indexOf(String(w)) != -1) {
			  return String(w);
			}*/
			  while (text.indexOf(String(w)) != -1)
			  {
				  trace(w);
				text = text.split(String(w)).join("");
			  }
			//return input.split(find).join(replace);
		  }
		  return text;
		  //return "";
		}
		// Helper that replaces all "find" with "replace" in the given input string
		public static function strReplace(input:String, find:String, replace:String):String {
		  while (input.indexOf(find) != -1)
			input = input.split(find).join(replace);
		  return input.split(find).join(replace);
		}	}}