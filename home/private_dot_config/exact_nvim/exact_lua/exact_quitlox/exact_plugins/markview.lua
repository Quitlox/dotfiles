-- +---------------------------------------------------------+
-- | OXY2DEV/markview.nvim: Markdown Render in Neovim        |
-- +---------------------------------------------------------+

local presets = require("markview.presets")
local filetypes = { "markdown", "codecompanion" }

require("markview").setup({
    preview = {
        filetypes = filetypes,
        icon_provider = "mini",

        modes = { "n", "no", "c" },
        hybrid_modes = { "n" },
        linewise_hybrid_mode = true,

        headings = { shift_width = 0 },
    },
    markdown = {},
    latex = {
        -- TODO: If these work well, I should contribute them to the main repo (in lua/markview/spec.lua)
        -- Map textsf command to use the same rendering as mathsf
        -- This adds support for \textsf{...} in text mode
        commands = {
            -- Simple textsf implementation that styles text without brackets
            ["textsf"] = {
                condition = function(item)
                    return #item.args == 1
                end,
                
                -- Hide the command
                on_command = {
                    conceal = ""
                },
                
                -- Handle the arguments
                on_args = {
                    {
                        -- Get the content
                        on_content = function(item)
                            -- Get just the content without braces
                            local text = item.args[1].text
                            local content = text:sub(2, #text - 1)
                            
                            -- Set highlight for the content
                            return {
                                hl = "MarkviewSpecial"
                            }
                        end,
                        
                        -- Handle opening brace
                        on_before = function(item)
                            return {
                                conceal = ""
                            }
                        end,
                        
                        -- Handle closing brace
                        on_after = function(item)
                            return {
                                conceal = ""
                            }
                        end
                    }
                }
            },
            -- Long space before "mod"
            ["mod"] = {
                condition = function(item)
                    return #item.args == 1
                end,
                on_command = {
                    conceal = "",
                    virt_text_pos = "inline",
                    virt_text = { { "   mod ", "@keyword.function" } },
                    hl_mode = "combine",
                },
                on_args = {
                    {
                        on_before = function(item)
                            return {
                                end_col = item.range[2] + 1,
                                virt_text_pos = "overlay",
                                virt_text = { { "(", "@punctuation.bracket" } },
                                hl_mode = "combine",
                            }
                        end,
                        after_offset = function(range)
                            return { range[1], range[2], range[3], range[4] - 1 }
                        end,
                        on_after = function(item)
                            return {
                                end_col = item.range[4],
                                virt_text_pos = "overlay",
                                virt_text = { { ")", "@punctuation.bracket" } },
                                hl_mode = "combine",
                            }
                        end,
                    },
                },
            },

            -- Short space before "mod"
            ["bmod"] = {
                condition = function(item)
                    return true
                end,
                on_command = {
                    conceal = "",
                    virt_text_pos = "inline",
                    virt_text = { { " mod ", "@keyword.function" } },
                    hl_mode = "combine",
                },
            },

            -- (mod ...) format
            ["pmod"] = {
                condition = function(item)
                    return #item.args == 1
                end,
                on_command = {
                    conceal = "",
                },
                on_args = {
                    {
                        on_before = function(item)
                            return {
                                end_col = item.range[2] + 1,
                                conceal = "",
                                virt_text_pos = "inline",
                                virt_text = { { " (mod ", "@keyword.function" } },
                                hl_mode = "combine",
                            }
                        end,
                        after_offset = function(range)
                            return { range[1], range[2], range[3], range[4] - 1 }
                        end,
                        on_after = function(item)
                            return {
                                end_col = item.range[4],
                                conceal = "",
                                virt_text_pos = "inline",
                                virt_text = { { ")", "@punctuation.bracket" } },
                                hl_mode = "combine",
                            }
                        end,
                    },
                },
            },
        },
    },
})

-- Load the checkboxes module.
require("markview.extras.checkboxes").setup()
vim.keymap.set("n", "X", ":Checkbox toggle<cr>", { desc = "Toggle Checkbox" })

--+- Keymap: Override Descriptions --------------------------+
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "codecompanion" },
    callback = function()
        -- Overwrite description of markview
        vim.keymap.set("n", "gx", "<cmd>Markview Open<cr>", { desc = "Open Link", buffer = 0 })
    end,
})
