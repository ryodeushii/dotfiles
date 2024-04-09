return {
    "mistricky/codesnap.nvim",
    build = "make",
    config = function()
        require("codesnap").setup({
            save_path = "~/Pictures/codesnap",
            has_breadcrumbs = true,
            bg_theme = "summer",
            watermark = ""
        })
    end
}
