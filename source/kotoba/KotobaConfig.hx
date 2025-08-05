package kotoba;

import haxe.xml.Access;

/**
 * KotobaConfig loads and stores the list of available languages and files from the config.xml.
 */
class KotobaConfig
{
	/** List of file paths used by the configuration. */
	private final files:Array<String> = [];

	/** List of supported language codes or names. */
	private final languages:Array<String> = [];

	/**
	 * Constructs a new KotobaConfig instance by parsing the provided XML configuration content.
	 *
	 * @param content The XML configuration as a string.
	 * 
	 * Parses the XML to extract file IDs and language names from the configuration.
	 * Throws an error if the root node is not "kotoba-config".
	 * Adds file IDs to the `files` array and language names to the `languages` array.
	 * Logs a warning if a <file> node is missing the "id" attribute or a <language> node is missing the "name" attribute.
	 */
	@:allow(kotoba.Kotoba)
	public function new(content:String):Void
	{
		final configXml:Xml = Xml.parse(content).firstElement();

		if (configXml.nodeName != "kotoba-config")
			throw 'Bad node name "${configXml.nodeName}", expected "kotoba-config"';

		final configAccess:Access = new Access(configXml);

		for (fileNode in configAccess.nodes.file)
		{
			if (fileNode.has.id)
				files.push(fileNode.att.id);
			else
				trace('Warning: <file> missing id attribute for the config file.');
		}

		for (langNode in configAccess.nodes.language)
		{
			if (langNode.has.name)
				languages.push(langNode.att.name);
			else
				trace('Warning: <language> missing name attribute at the config file.');
		}
	}

	/**
	 * Returns the list of files associated with this configuration.
	 * 
	 * @return An array of file paths as strings.
	 */
	public function getFiles():Array<String>
	{
		return files;
	}

	/**
	 * Returns the list of languages supported by this configuration.
	 * 
	 * @return An array of language codes or names as strings.
	 */
	public function getLanguages():Array<String>
	{
		return languages;
	}

	/**
	 * Returns a string representation of the KotobaFile object, including its languages and files.
	 *
	 * @return A string in the format 'KotobaFile<languages, files>'.
	 */
	@:keep
	public function toString():String
	{
		return 'KotobaFile<$languages, $files>';
	}
}
