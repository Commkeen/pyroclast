package org.pyroclast.ai.Conditions 
{
	/**
	 * ...
	 * @author John Lynk
	 */
	public class FunctionCondition implements IStateCondition 
	{
		protected var _test:Function;
		
		public function FunctionCondition( testFunction:Function ) 
		{
			_test = testFunction;
		}
		
		/* INTERFACE com.john.Jumper.IStateCondition */
		
		public function test():Boolean 
		{
			return _test();
		}
		
	}

}