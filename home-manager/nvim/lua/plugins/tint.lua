return {
  {
    "levouh/tint.nvim",
    config = function()
      local tint = require("tint")
      tint.setup({
        tint = -50,                                            -- Darken colors, use a positive value to brighten
        saturation = 0.6,                                      -- Saturation to preserve
        transforms = require("tint").transforms.SATURATE_TINT, -- Showing default behavior, but value here can be predefined set of transforms
        tint_background_colors = false,                        -- Tint background portions of highlight groups
      })
    end
  },
}
