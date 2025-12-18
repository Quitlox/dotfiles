local gen_spec = require("mini.ai").gen_spec

-- We add `%b<>` as argument brackets for generics
vim.b.miniai_config = {
    custom_textobjects = {
        a = gen_spec.argument({ brackets = { "%b()", "%b[]", "%b{}", "%b<>" } }),
    },
}
