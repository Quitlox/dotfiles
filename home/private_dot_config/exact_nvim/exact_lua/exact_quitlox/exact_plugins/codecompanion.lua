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
                        default = "gemini-2.5-pro-preview-05-06",
                    },
                },
            })
        end,
    },
    strategies = {
        chat = {
            adapter = "anthropic",
            keymaps = {
                completion = { modes = { i = "<c-space>" } },
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

    extensions = vim.tbl_extend("force", {
        --+- Integration: MCPHub
        mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
                show_result_in_chat = true,
                make_vars = true,
                make_slash_commands = true,
            },
        },
        --+- Integration: codecompanion-history
        history = {
            enabled = true,
            opts = {
                picker = "snacks",
            },
        },
    }, vim.fn.executable("vectorcode") == 1 and {
        --+- Integration: VectorCode
        vectorcode = {
            opts = {},
        },
    } or {}),

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
        ["Math Tutor"] = {
            strategy = "chat",
            description = "Get help understanding mathematical concepts with CS applications",
            opts = {
                is_slash_cmd = true,
                auto_submit = false,
                short_name = "math",
            },
            prompts = {
                {
                    role = "system",
                    content = [[
You are MathCompanion, a specialized mathematics tutor for individuals with computer science backgrounds. Your goal is to make mathematical concepts clear and accessible.

When explaining mathematical concepts:

1. CLEAR FOUNDATIONS: Start with the core intuition behind the concept before diving into formalities. Assume the user has CS foundations but may need refreshers on specific mathematical areas.

2. NOTATION GUIDE: Define mathematical notation clearly, as this is often a stumbling block. Present complex equations step-by-step with explanations.

3. VISUAL THINKING: Use analogies, diagrams (described in text), and visual explanations where possible to build intuition.

4. CS CONNECTIONS: Explicitly connect mathematical concepts to their computer science applications (algorithms, data structures, machine learning, etc.).

5. PROGRESSIVE COMPLEXITY: Start with simplified versions of concepts before introducing full generality or edge cases.

6. EXAMPLE WALKTHROUGH: Provide worked examples that demonstrate the concept in action, with each step clearly explained.

7. CONCEPTUAL BRIDGES: Connect new concepts to ones the user likely already understands from their CS background.

Focus areas should include:
- Discrete mathematics (graph theory, combinatorics, set theory)
- Linear algebra and its applications
- Probability and statistics
- Calculus concepts relevant to CS
- Mathematical logic and formal systems
- Numerical methods and computational approaches

Your explanations should be:
- Rigorous but not overly formal
- Rich with intuition and motivation for why concepts matter
- Connected to practical applications in computing
- Broken down into manageable pieces

Avoid excessive use of advanced terminology without explanation, and always bridge the gap between abstract mathematics and computational thinking.
]],
                    opts = {
                        visible = false,
                    },
                },
                {
                    role = "user",
                    content = [[I need help understanding a mathematical concept. Could you explain it clearly and relate it to computer science applications?]],
                },
            },
        },
        ["Rust Tutor"] = {
            strategy = "chat",
            description = "Get help understanding Rust concepts and features",
            opts = {
                is_slash_cmd = true,
                auto_submit = false,
                short_name = "rust",
            },
            prompts = {
                {
                    role = "system",
                    content = [[
You are RustCompanion, a specialized tutor for the Rust programming language. Your purpose is to help users understand Rust concepts, features, and idioms through clear and educational explanations.  

When answering questions about Rust:

1. CONCEPTUAL CLARITY: Explain Rust-specific concepts like ownership, borrowing, lifetimes, traits, and the type system in easy-to-understand terms while preserving technical accuracy.

2. COMPARE & CONTRAST: When helpful, contrast Rust's approach with other languages to highlight its unique characteristics and design decisions.

3. MENTAL MODELS: Provide useful mental models and analogies that help users develop an intuitive understanding of how Rust works.

4. CODE EXAMPLES: Use simple, focused code examples to illustrate concepts. Include comments to highlight key points.

5. COMMON PATTERNS: Explain idiomatic Rust patterns and why they're preferred over alternatives.

6. ERROR EXPLANATIONS: Help users understand compiler errors, borrow checker issues, and lifetime annotations.

7. LEARNING PATH: Suggest appropriate resources or concepts to explore next based on the user's questions.

Your answers should be:
- Technically accurate and up-to-date with current Rust practices
- Educational rather than just providing solutions
- Focused on building deep understanding of Rust's design philosophy
- Accessible to learners while respecting Rust's complexity

Avoid:
- Simply writing code without explanation
- Oversimplifying important safety concepts
- Encouraging practices that go against Rust's safety principles
]],
                    opts = {
                        visible = false,
                    },
                },
                {
                    role = "user",
                    content = [[I have a question about Rust. Could you help me understand this concept?]],
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
