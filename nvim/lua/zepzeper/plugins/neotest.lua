-- require("neotest").setup({
--     adapters = {
--         require("neotest-phpunit")({
--             phpunit_cmd = function()
--                 local file = vim.fn.expand("%")
--                 local ok, lines = pcall(vim.fn.readfile, file)
--                 local config = "/data/www/useracademy/codebase/tools/phpunit/unit/phpunit.xml.dist"
--
--                 if ok then
--                     local content = table.concat(lines, "\n")
--                     if content:match("#%[Group%(['\"]integration['\"]%)%]") then
--                         config = "/data/www/useracademy/codebase/tools/phpunit/integration/phpunit.xml.dist"
--                     end
--                 end
--
--                 local cmd = {
--                     "docker",
--                     "exec",
--                     "probase-webserver",
--                     "php",
--                     "/data/www/useracademy/codebase/vendor/bin/phpunit",
--                     "--configuration",
--                     config,
--                 }
--                 print(vim.inspect(cmd))
--                 return cmd
--             end,
--             root_files = { "composer.json", "phpunit.xml.dist", ".gitignore" },
--         })
--     },
-- })

local phpunit = require("neotest-phpunit")({
    root_files = { "composer.json", "phpunit.xml.dist", ".gitignore" },
})

local original_build_spec = phpunit.build_spec

local function get_phpunit_config(path)
    if not path then
        return "/data/www/useracademy/codebase/tools/phpunit/unit/phpunit.xml.dist"
    end
    local ok, lines = pcall(vim.fn.readfile, path)
    if ok then
        local content = table.concat(lines, "\n")
        if content:match("#%[Group%(['\"]integration['\"]%)%]") then
            return "/data/www/useracademy/codebase/tools/phpunit/integration/phpunit.xml.dist"
        end
    end
    return "/data/www/useracademy/codebase/tools/phpunit/unit/phpunit.xml.dist"
end

phpunit.build_spec = function(args)
    local spec = original_build_spec(args)
    if not spec then return nil end

    local path = args.tree and args.tree:data().path
    local config = get_phpunit_config(path)

    -- rewrite --log-junit to container volume path
    for i, arg in ipairs(spec.command) do
        if type(arg) == "string" and arg:match("^--log%-junit=") then
            local host_path = arg:match("^--log%-junit=(.+)$")
            local container_path = host_path:gsub("^/tmp/", "/data/www/useracademy/codebase/.phpunit.cache/neotest-")
            spec.command[i] = "--log-junit=" .. container_path
            spec.context.results_path = container_path:gsub(
                "^/data/www/useracademy/codebase",
                "/data/probase.git"
            )
            break
        end
    end

    -- rewrite host paths to container paths
    for i, arg in ipairs(spec.command) do
        if type(arg) == "string" and arg:match("^/data/probase%.git") then
            spec.command[i] = arg:gsub("^/data/probase%.git", "/data/www/useracademy/codebase")
        end
    end

    -- prepend docker exec with the correct config
    spec.command = vim.tbl_flatten({
        "docker", "exec", "probase-webserver",
        "php", "/data/www/useracademy/codebase/vendor/bin/phpunit",
        "--configuration", config,
        vim.list_slice(spec.command, 2),
    })

    return spec
end

require("neotest").setup({
    adapters = { phpunit },
})

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local ft = vim.bo.filetype
        if ft ~= "php" then
            pcall(vim.api.nvim_del_augroup_by_name, "neotest.Client")
        end
    end,
})
