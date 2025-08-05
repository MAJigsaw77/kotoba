package kotoba;

/**
 * KotobaReplacer replaces placeholders in strings with values from a parameter object.
 */
class KotobaReplacer
{
	/**
	 * Replaces placeholders in the given text with corresponding values from the `params` object.
	 * 
	 * Placeholders are in the format `$key`, where `key` consists of alphanumeric characters and underscores.
	 * For each placeholder found, if `params` contains a field with the same name as `key`, it is replaced
	 * with the string value of that field. Otherwise, the placeholder is left unchanged.
	 * 
	 * @param text The input string containing placeholders to be replaced.
	 * @param params A dynamic object containing key-value pairs for replacement.
	 * @return The resulting string with placeholders replaced by their corresponding values.
	 */
	public static function replace(text:String, params:Dynamic):String
	{
		var regex:EReg = ~/\$([a-zA-Z0-9_]+)/;
		var result:String = "";
		var lastIndex:Int = 0;

		while (true)
		{
			final subText:String = text.substr(lastIndex, text.length - lastIndex);

			if (!regex.match(subText))
				break;

			final mpos:{pos:Int, len:Int} = regex.matchedPos();
			final start:Int = lastIndex + mpos.pos;
			final end:Int = start + mpos.len;
			final wholeMatch:String = regex.matched(0);
			final key:String = regex.matched(1);

			result += text.substring(lastIndex, start);

			if (Reflect.hasField(params, key))
				result += Std.string(Reflect.field(params, key));
			else
				result += wholeMatch;

			lastIndex = end;
		}

		result += text.substring(lastIndex);

		return result;
	}
}
