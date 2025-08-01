-- ~/.config/nvim/snippets/cpp.lua
local ls = require("luasnip")
local s = ls.snippet            -- defines a snippet
local t = ls.text_node          -- plain text
local i = ls.insert_node        -- interactive input field
local c = ls.choice_node        -- choice input field
local d = ls.dynamic_node       -- dynamic input field
local sn = ls.snippet_node      -- another snippet node
local fmt = require("luasnip.extras.fmt").fmt  -- format template
local rep = require("luasnip.extras").rep      -- repeat previous input
local function capture_first(_, snip)
    return snip.captures[1]
end

return {
    -- Main function
    s("main", fmt([[
        int main(int argc, char* argv[]) {{
            {}
            return 0;
        }}
    ]], { i(1, "// code") })),

    -- for loop with i as index
    s("fori", fmt([[
        for (unsigned i = 0; i < {}; ++i) {{
            {}
        }}
    ]], { i(1, "range"), i(2, "code"), })),
    
    -- for loop with j as index
    s("forj", fmt([[
        for (unsigned j = 0; j < {}; ++j) {{
            {}
        }}
    ]], { i(1, "range"), i(2, "code"), })),
    
    -- for loop with k as index
    s("fork", fmt([[
        for (unsigned k = 0; k < {}; ++k) {{
            {}
        }}
    ]], { i(1, "range"), i(2, "code"), })),

    -- cout with '\n'
    s("coutn", fmt([[
        std::cout << {} << '\n';
    ]], { i(1, "message") })),

    -- cout with ' '
    s("cout'", fmt([[
        std::cout << {} << ' ';
    ]], { i(1, "message") })),

    s("nl", t("std::cout << '\\n';")),

    s({trig="vg ([xlmcC]_[%w_]+)", regTrig=true}, fmt([[
        , vget({})
    ]], { f(capture_first) })),

    -- For loop with range
    s({trig="for%((%S+)%)", regTrig=true}, fmt([[
        for (const auto &elem : {}) {{
            {}
        }}
    ]], { f(capture_first), i(1, "code") })),

    -- Include guard
    s("ifndef", fmt([[
        #ifndef {}
        #define {}

        {}

        #endif // {}
    ]], { i(1, "HEADER_H"), rep(1), i(2, "// content"), rep(1) })),

    s({trig="inc_(%w+)", wordTrig=false, regTrig=true}, fmt([[
        #include <{}>
    ]], { f(capture_first) })),
}
