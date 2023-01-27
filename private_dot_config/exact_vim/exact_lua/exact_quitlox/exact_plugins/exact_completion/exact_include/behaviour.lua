local function select_next_completion_item(fallback, count)
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    if cmp.visible() then
        cmp.select_next_item({ count = count or 1 })
    elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        -- Note: This is in the default config, but breaks <tab> when positioned at the end of a word in insert mode
        -- elseif has_words_before() then
        -- 	cmp.complete()
    else
        fallback()
    end
end

local function select_prev_completion_item(fallback)
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    if cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
    else
        fallback()
    end
end

local function scroll_completion_down()
    local cmp = require("cmp")

    -- If the Documentation View is visible, scroll the documentation
    if cmp.core.view.docs_view:visible() then
        cmp.core.view:scroll_docs(4)
        return
    end

    -- Otherwise, jump through half of the visible entries
    if cmp.core.view.custom_entries_view:visible() then
        -- attributes: border_info, col, height, inner_height, inner_width, row, scrollabe, scrollbar_offset, width
        local window_info = cmp.core.view.custom_entries_view:info()
        local height = window_info.height
        cmp.select_next_item({ count = math.floor(height / 2) })
    end
end

local function scroll_completion_up()
    local cmp = require("cmp")

    -- If the Documentation View is visible, scroll the documentation
    if cmp.core.view.docs_view:visible() then
        cmp.core.view:scroll_docs(-4)
        return
    end

    -- Otherwise, jump through half of the visible entries
    if cmp.core.view.custom_entries_view:visible() then
        -- attributes: border_info, col, height, inner_height, inner_width, row, scrollabe, scrollbar_offset, width
        local window_info = cmp.core.view.custom_entries_view:info()
        local height = window_info.height
        cmp.select_prev_item({ count = math.floor(height / 2) })
    end
end

return {
    select_next_completion_item = select_next_completion_item,
    select_prev_completion_item = select_prev_completion_item,
    scroll_completion_down = scroll_completion_down,
    scroll_completion_up = scroll_completion_up,
}
