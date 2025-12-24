# Title: Trouble.nvim - Filter Diagnostics by Source
# Category: plugins
# Tags: trouble.nvim, diagnostics, filtering, lsp
---
Trouble.nvim supports filtering diagnostics by their source (linter/LSP). Use `filter` to include only specific sources, or `filter.not` to exclude sources.

**Include only diagnostics from a specific source:**
```vim
:Trouble diagnostics filter={ ["item.source"] = "pylint" }
```

**Exclude diagnostics from a specific source:**
```vim
:Trouble diagnostics filter.not={ ["item.source"] = "Harper" }
```

You can also filter by other properties like `severity`, `ft` (filetype), `buf` (buffer), `kind` (symbol kind), or combine multiple filters for more control.
***
