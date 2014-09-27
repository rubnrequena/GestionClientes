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
		static public function toArray (data:*):Array {
			var a:Array = new Array(data.length);
			var i:int;
			for (i = 0; i < a.length; i++)
				a[i]=data[i]
			return a;
		}
	}
}