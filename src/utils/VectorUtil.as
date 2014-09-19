package utils
{
	public class VectorUtil
	{
		static public function toVector (data:Array,vectorClass:*):* {
			var vector:* = new vectorClass();
			if (data) {
				var i:int;
				for (i = 0; i < data.length; i++) vector[i]=data[i];
			}
			return vector;
		}
	}
}