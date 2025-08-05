package;

import kotoba.Kotoba;
import kotoba.KotobaLoader;
import kotoba.KotobaReplacer;

import sys.FileSystem;
import sys.io.File;

class Main
{
	public static function main():Void
	{
		// Intialize the functions to load files.
		KotobaLoader.exists = FileSystem.exists;
		KotobaLoader.getContent = File.getContent;

		// Set a language.
		Kotoba.language = 'ro-RO';

		// Intialize Kotoba.
		Kotoba.initialize('assets/translations');

		// Trace the string in the console.
		trace(KotobaReplacer.replace(Kotoba.getString('example_file', 'example_id', 'Unable to find phrase!'), {money: 20}));
	}
}
