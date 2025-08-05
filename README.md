![](./assets/kotoba.png)

# kotoba

![](https://img.shields.io/github/repo-size/MAJigsaw77/kobota) ![](https://badgen.net/github/open-issues/MAJigsaw77/kobota) ![](https://badgen.net/badge/license/MIT/green)

A lightweight Haxe library for XML-based language configuration and translation management.

### Installation

Using **Haxelib**:
```bash
haxelib install kotoba
```

Using **Git** (for latest changes):
```bash
haxelib git kotoba https://github.com/MAJigsaw77/kotoba.git
```

### How It Works

Kotoba loads translation files defined in a `config.xml`. You can organize your folders however you like — just make sure `Kotoba.initialize(path)` points to the directory containing `config.xml`, and the config lists your language folders and file IDs.

### Example File Structure

```
assets/
└── translations/
	├── config.xml
	├── en-US/
	│   └── example_file.xml
	└── ro-RO/
		└── example_file.xml
```

### `config.xml`

```xml
<kotoba-config>
	<file id="example_file" />
	<language name="en-US" />
	<language name="ro-RO" />
</kotoba-config>
```

### 🇺🇸 `en-US/example_file.xml`

```xml
<kotoba-file>
	<string key="example_id" value="You earned $money!" />
</kotoba-file>
```

### 🇷🇴 `ro-RO/example_file.xml`

```xml
<kotoba-file>
	<string key="example_id" value="Ai câștigat $money lei!" />
</kotoba-file>
```

### Usage

```haxe
import kotoba.Kotoba;
import kotoba.KotobaLoader;
import kotoba.KotobaReplacer;

import sys.FileSystem;
import sys.io.File;

class Main
{
	public static function main():Void
	{
		// Hook Kotoba into your file loading logic
		KotobaLoader.exists = FileSystem.exists;
		KotobaLoader.getContent = File.getContent;

		// Choose a language
		Kotoba.language = 'ro-RO';

		// Load translations from folder
		Kotoba.initialize('assets/translations');

		// Fetch and format a translated string
		final raw:String = Kotoba.getString('example_file', 'example_id', 'Fallback text');

		final result:String = KotobaReplacer.replace(raw, { money: 20 });

		trace(result); // → Ai câștigat 20 lei!
	}
}
```

---

### License

**kotoba** is released under the MIT License. See [LICENSE](./LICENSE) for details.
