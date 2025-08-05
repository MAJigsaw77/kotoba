package kotoba;

import haxe.xml.Access;

/**
 * KotobaFile represents a single language file and provides access to its strings.
 */
class KotobaFile
{
	/** A map that stores string key-value pairs. */
	private final strings:Map<String, String> = [];

	/**
	 * Constructs a new KotobaFile instance by parsing the provided XML content.
	 *
	 * @param name The name of the file being loaded.
	 * @param content The XML content of the file as a string.
	 * @throws String If the root node name is not "kotoba-file".
	 *
	 * The constructor parses the XML content, checks for the correct root node,
	 * and initializes the internal string map with key-value pairs found in the
	 * <string> nodes. If a <string> node is missing the "key" or "value" attribute,
	 * a warning is traced.
	 */
	@:allow(kotoba.Kotoba)
	private function new(name:String, content:String):Void
	{
		final kotobaFileContent:Xml = Xml.parse(content).firstElement();

		if (kotobaFileContent.nodeName != 'kotoba-file')
			throw 'Bad node name "${kotobaFileContent.nodeName}", expected "kotoba-file"';

		final kotobaFileAccess:Access = new Access(kotobaFileContent);

		for (string in kotobaFileAccess.nodes.string)
		{
			if (string.has.key && string.has.value)
			{
				final stringKey:String = string.att.key;
				final stringValue:String = string.att.value;

				strings.set(stringKey, stringValue);
			}
			else
				trace('Warning: <string> missing key or value attribute "$string" at "$name".');
		}
	}

	/**
	 * Retrieves the string value associated with the specified key.
	 * 
	 * @param key The key to look up in the strings map.
	 * @param fallback (Optional) The value to return if the key does not exist.
	 * @return The string value associated with the key, or the fallback value if the key is not found.
	 */
	public function get(key:String, ?fallback:String):Null<String>
	{
		return strings.exists(key) ? strings.get(key) : fallback;
	}

	/**
	 * Returns a string representation of the KotobaFile instance.
	 * 
	 * @return A string in the format 'KotobaFile<$strings>'.
	 */
	@:keep
	public function toString():String
	{
		return 'KotobaFile<$strings>';
	}
}
