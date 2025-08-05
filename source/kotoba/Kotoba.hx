package kotoba;

import haxe.io.Path;

import kotoba.KotobaLoader;
import kotoba.KotobaConfig;
import kotoba.KotobaFile;

/**
 * Kotoba is the main API for handling translations.
 *
 * It loads language files defined in a `config.xml` and allows retrieving translated strings by file and key, for a selected language.
 *
 * The translation files are expected to be XML files, with each file containing multiple key-value string entries.
 */
class Kotoba
{
	/**
	 * The currently selected language, or null if not set.
	 */
	public static var language:Null<String>;

	@:noCompletion
	private static var langs:Map<String, Map<String, KotobaFile>> = [];

	@:noCompletion
	private static var directory:Null<String>;

	@:noCompletion
	private static var config:Null<KotobaConfig>;

	/**
	 * Initializes the Kotoba system with the specified directory.
	 *
	 * This function sets the internal directory, checks for the existence of a "config.xml" file
	 * within the directory, and loads its content if available. If any step fails (e.g., the directory
	 * is null or empty, the config file is missing, or its content cannot be read), an error message
	 * is traced and initialization is aborted.
	 *
	 * @param directory The path to the directory containing the "config.xml" configuration file.
	 */
	public static function initialize(directory:String):Void
	{
		Kotoba.directory = directory;

		if (directory == null || directory.length == 0)
		{
			trace('Error: Directory is null or empty. Initialization aborted.');
			return;
		}

		final configPath:String = Path.join([directory, "config.xml"]);

		if (!KotobaLoader.exists(configPath))
		{
			trace('Error: Cannot find "config.xml" in "' + directory + '".');
			return;
		}

		final configContent:Null<String> = KotobaLoader.getContent(configPath);

		if (configContent == null || configContent.length == 0)
		{
			trace('Error: Cannot get "config.xml" content.');
			return;
		}

		loadConfig(configContent);
	}

	/**
	 * Retrieves a localized string from the specified file using the given key.
	 * 
	 * @param file The name or path of the file containing the localized strings.
	 * @param key The key identifying the desired string within the file.
	 * @param fallback (Optional) A fallback string to return if the key is not found.
	 * @return The localized string if found, otherwise the fallback string or null.
	 */
	public static function getString(file:String, key:String, ?fallback:String):Null<String>
	{
		if (language == null || language.length <= 0)
		{
			trace('Error: No language set or empty language string.');
			return null;
		}

		if (!langs.exists(language))
		{
			trace('Error: Language "' + language + '" not loaded.');
			return null;
		}

		var langFiles:Null<Map<String, KotobaFile>> = langs.get(language);

		if (langFiles == null || !langFiles.exists(file))
		{
			trace('Error: File "' + file + '" not found for language "' + language + '".');
			return fallback;
		}

		var kotobaFile:Null<KotobaFile> = langFiles.get(file);

		if (kotobaFile == null)
		{
			trace('Error: KotobaFile for file "' + file + '" is null.');
			return fallback;
		}

		return kotobaFile.get(key, fallback);
	}

	@:noCompletion
	private static function loadConfig(configContent:String):Void
	{
		if (Lambda.count(langs) > 0)
			langs.clear();

		config = new KotobaConfig(configContent);

		for (lang in config.getLanguages())
			loadLanguage(lang);
	}

	@:noCompletion
	private static function loadLanguage(lang:String):Void
	{
		if (config != null)
		{
			final files:Map<String, KotobaFile> = [];

			for (file in config.getFiles())
				loadLanguageFile(lang, file, files);

			langs.set(lang, files);
		}
	}

	@:noCompletion
	private static function loadLanguageFile(lang:String, file:String, files:Map<String, KotobaFile>):Void
	{
		if (directory == null || directory.length == 0)
			return;

		final langFilePath:String = Path.join([directory, lang, Path.withExtension(file, "xml")]);

		if (!KotobaLoader.exists(langFilePath))
			return;

		final langFileContent:Null<String> = KotobaLoader.getContent(langFilePath);

		if (langFileContent == null || langFileContent.length == 0)
			return;

		files.set(file, new KotobaFile(file, langFileContent));
	}
}
