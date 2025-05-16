-- +---------------------------------------------------------+
-- | olimorris/codecompanion.nvim                            |
-- +---------------------------------------------------------+

require("codecompanion").setup({
    adapters = {
        gemini_pro = function()
            return require("codecompanion.adapters").extend("gemini", {
                name = "gemini_pro",
                schema = {
                    model = {
                        default = "gemini-2.5-pro-exp-03-25",
                    },
                },
            })
        end,
    },
    strategies = {
        chat = {
            adapter = "anthropic",
            keymaps = {
                completion = { modes = { i = "<leader>cx" } },
                change_adapter = { modes = { n = "gA" } },
                previous_chat = { modes = { n = "[c" } },
                next_chat = { modes = { n = "]c" } },
            },
            slash_commands = {
                --+- Integration: snacks.nvim
                ["file"] = {
                    opts = {
                        provider = "snacks",
                    },
                },
            },
        },
        inline = {
            adapter = "anthropic",
            keymaps = {
                accept_change = { modes = { n = "<leader>ca" } },
                reject_change = { modes = { n = "<leader>cr" } },
            },
        },
    },

    extensions = {
        --+- Integration: VectorCode
        vectorcode = {
            opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
        },
        --+- Integration: MCPHub
        mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
                show_result_in_chat = true,
                make_vars = true,
                make_slash_commands = true,
            },
        },
    },

    prompt_library = {
        ["Research Paper Analysis"] = {
            strategy = "chat",
            description = "Get help understanding a research paper",
            opts = {
                is_slash_cmd = true,
                auto_submit = false,
                short_name = "paper",
            },
            prompts = {
                {
                    role = "system",
                    content = [[
You are ResearchCompanion, an AI research assistant specialized in helping users understand academic papers. Your goal is to break down complex research into clear, accessible explanations while maintaining scientific accuracy.

Approach each paper systematically:

1. SUMMARY: Begin with a concise 3-5 sentence summary of the paper's core findings, methodology, and significance.

2. KEY ELEMENTS: Identify and explain:
   - Main research question/hypothesis
   - Methodology used
   - Key findings and their implications
   - Notable limitations or gaps acknowledged
   - How this research connects to the broader field

3. TERMINOLOGY: Define important technical terms or concepts in plain language.

4. VISUAL ELEMENTS: When users share figures, tables, or equations, explain what they represent and why they matter.

5. CRITICAL ANALYSIS: When appropriate, discuss:
   - Strengths and weaknesses of the approach
   - Alternative interpretations of the data
   - How this work confirms or challenges existing literature
   - Potential applications or future research directions

When responding to specific questions:
- Focus precisely on what was asked
- Cite specific sections/figures from the paper when relevant
- Acknowledge when something is unclear in the original text
- Avoid making claims beyond what the paper supports

Always maintain a scientific, educational tone while making the content accessible to someone with general knowledge in the field but who may not be an expert in this specific topic.
]],
                    opts = {
                        visible = false,
                    },
                },
                {
                    role = "user",
                    content = [[Please help me understand the research paper I'll share with you. I'd like a clear explanation of its key findings, methodology, and significance in the field.]],
                },
            },
        },
        ["Translate"] = {
            strategy = "chat",
            description = "Translate words between languages",
            opts = {
                is_slash_cmd = true,
                auto_submit = false,
                short_name = "translate",
            },
            prompts = {
                {
                    role = "system",
                    content = [[
You are TranslationCompanion, a precise and efficient language translator. Your task is to translate words or short phrases between any languages accurately.

When providing translations:
1. Include the original word and its translation
2. Add the phonetic pronunciation when appropriate
3. Include common usage examples in both languages
4. Note any relevant cultural context that affects meaning
5. Mention if there are multiple possible translations depending on context

Be concise and focus solely on accurate translation without unnecessary commentary.
]],
                    opts = {
                        visible = false,
                    },
                },
                {
                    role = "user",
                    content = [[Please translate the following word/phrase. I'll specify the source and target languages.]],
                },
            },
        },
    },
})

--+- Integration: fidget.nvim -------------------------------+
require("integrations.codecompanion-fidget"):init()

--+- Keymaps ------------------------------------------------+
-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle Chat" })
vim.keymap.set("v", "<leader>C", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

--+- Commands -----------------------------------------------+
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
