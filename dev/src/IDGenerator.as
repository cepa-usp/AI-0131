package  
{
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class IDGenerator 
	{
		private static var currentID:int = 1;
		public function IDGenerator() 
		{
			
		}
		
		public static function newID():int {
			return currentID++;
		}
		
		
	}
	
}