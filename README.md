# monoscope.vim

Telescope extension to search within mono repository by offering ways to restrict the amount of shown folders and file types.
Can be configured to only show folders of a coder owner with respect to a codeowner file.

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

