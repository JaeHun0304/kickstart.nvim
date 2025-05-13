-- ~/.config/nvim/snippets/cpp.lua
local ls = require("luasnip")
local s = ls.snippet            -- defines a snippet
local t = ls.text_node          -- plain text
local i = ls.insert_node        -- interactive input field
local fmt = require("luasnip.extras.fmt").fmt  -- format template
local rep = require("luasnip.extras").rep      -- repeat previous input

return {
    -- Main function
    s("main", fmt([[
        int main(int argc, char* argv[]) {{
            {}
            return 0;
        }}
    ]], { i(1, "// code") })),

    -- cout with '\n'
    s("coutn", fmt([[
        std::cout << {} << '\n';
    ]], { i(1, "message") })),

    -- For loop
    s("fori", fmt([[
        for (int {} = 0; {} < {}; ++{}) {{
            {}
        }}
    ]], { i(1, "i"), rep(1), i(2, "n"), rep(1), i(3, "// code") })),

    -- Include guard
    s("ifndef", fmt([[
        #ifndef {}
        #define {}

        {}

        #endif // {}
    ]], { i(1, "HEADER_H"), rep(1), i(2, "// content"), rep(1) })),
}
