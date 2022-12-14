----------------------------------------------------------------------
--                             Comment                              --
----------------------------------------------------------------------

import({ "Comment", "which-key" }, function(modules)
    local comment = modules['Comment']
    local wk = modules['which-key']

    comment.setup({
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            ---Line-comment toggle keymap
            line = 'gcc',
            ---Block-comment toggle keymap
            block = 'gbc',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = 'gc',
            ---Block-comment keymap
            block = 'gb',
        },
        ---LHS of extra mappings
        extra = {
            ---Add comment on the line above
            above = 'gcO',
            ---Add comment on the line below
            below = 'gco',
            ---Add comment at the end of line
            eol = 'gcA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = true,
        },
        ---Function to call before (un)comment
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        ---Function to call after (un)comment
        post_hook = nil,
    })

    -- wk.register({
    --     c = {
    --         name="Comment",
    --         c ="Toggle Comment",
    --         b = "Toggle Block Comment",
    --         o = "Insert Comment Next Line",
    --         O = "Insert Comment Prev Line",
    --         A = "Insert Comment End Line",
    --         w = "Toggle Comment Word",
    --     }
    -- }, {prefix="g"})
    --
    -- wk.register({
    --     c = {
    --         name="Comment",
    --         c ="Toggle Comment",
    --         b = "Toggle Block Comment",
    --     }
    -- }, {prefix="g", mode='v'})
end)

----------------------------------------------------------------------
--                          Comment Frame                           --
----------------------------------------------------------------------

import({ "nvim-comment-frame", "which-key" }, function(modules)
    local wk = modules["which-key"]
    local frame = modules["nvim-comment-frame"]

    frame.setup()
    wk.register({
        h = { frame.add_comment, "Comment Header" },
        H = { frame.add_multiline_comment, "Comment Header (multi-line)" },

    }, { prefix = "gc" })

end)

----------------------------------------------------------------------
--                   Neogen: Annotation Generator                   --
----------------------------------------------------------------------

import({ "neogen", "which-key" }, function(modules)
    local neogen = modules.neogen
    local wk = modules["which-key"]

    neogen.setup({ snippet_engine = "luasnip" })
    wk.register({
        f = { neogen.generate, "Comment Function" }
    }, { prefix = "gc" })
end)
