local load = function(mod)
  package.loaded[mod] = nil
  require(mod)
end

load('custom.setting')
load('custom.keymap')
load('custom.state_dirs')
require("lazy_config")
