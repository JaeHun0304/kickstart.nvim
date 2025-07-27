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
local function create_cout_args(_, snip)
    local nodes = {}
    local count = tonumber(snip.captures[1]) or 0
    for j = 1, count do
        table.insert(nodes, i(j, "arg" .. j))
        if j < count then
            table.insert(nodes, t(" << "))
        end
    end
    return sn(nil, nodes)
end
local function capture_first(_, snip)
    return snip.captures[1]
end
local function capture_second(_, snip)
    return snip.captures[2]
end
local function cout_with_vars(_, snip)
    local args = snip.captures[2]
    local words = {}

    for word in string.gmatch(args, "[%w_]+") do
        table.insert(words, string.format("\" %s:\" << %s", word, word))
    end
    table.insert(words, 1, string.format("\"%s:\" << %s", snip.captures[1], snip.captures[1]))

    return table.concat(words, " << ")
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

    -- cout with '\n'
    s("coutn", fmt([[
        std::cout << {} << '\n';
    ]], { i(1, "message") })),

    -- cout with ' '
    s("cout'", fmt([[
        std::cout << {} << ' ';
    ]], { i(1, "message") })),

    s("nl", t("std::cout << '\\n';")),

    s("print ", fmt([[
        printf("{}");
    ]], { i(1, "msg") })),

    s({trig="vg ([xlmcC]_%S+) ", regTrig=true}, fmt([[
        , vget({})
    ]], { f(capture_first) })),

    s({trig="cout(%d+)", regTrig=true}, fmt([[
        std::cout << {} << '\n';
    ]], { d(1, create_cout_args, {}, { user_args = nil})})),

    s({trig="([xlmcC]_[%w_-]+)%s", regTrig=true}, fmt([[
        " {}:" << {} << 
    ]], { f(capture_first), f(capture_first) })),

    s({trig="cout%(([%w_]+),?([%w_,]*)%)", regTrig=true}, fmt([[
        std::cout << {} << '\n';
    ]], { f(cout_with_vars) })),

    -- For loop
    s({trig="for%(([%w_-]+)%)%((%S+)%)", regTrig=true}, fmt([[
        for (unsigned {} = 0; {} < {}; ++{}) {{
            {}
        }}
    ]], { f(capture_first), f(capture_first), f(capture_second), f(capture_first), i(1, "code") })),
    
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

    s({trig="inc_(%w+) ", wordTrig=false, regTrig=true}, fmt([[
        #include <{}>
    ]], { f(capture_first) })),
}
