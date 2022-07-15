# monoscope.vim

Telescope extension to search within mono repository by offering ways to restrict the amount of shown files and folders.
Can be configured to only show folders from a codeowner files and restrict the shown file types.

## Installation

Use your favorite plugin manager.

## Configuration

```
require("monoscope").setup({
	owner = "@ownername",
	ownerfile = "/path/to/code/CODEOWNERS",
	folders = {
		{
      owner = true,
			path = "/path/to/folder/in/monorepo",
			filetypes = { "go", "proto" },
		},
		{
      owner = true,
			path = "/path/to/folder/in/monorepo",
			filetypes = { "dart", "go" },
		},
		{
			path = "/path/to/folder/in/monorepo",
		},
	},
})
```

## Usage

Set a keymap to
```
require("monoscope").folders()
```

