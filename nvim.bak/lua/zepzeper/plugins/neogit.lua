local neogit = require("neogit")

neogit.setup({
    status = {
        show_head_commit_hash = true,
        recent_commit_count = 10,
        HEAD_padding = 10,
        HEAD_folded = false,
        mode_padding = 3,
    },

    git_services = {
        ["git.procurios.net"] = {
            pull_request = "https://git.procurios.net/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
            commit = "https://git.procurios.net/${owner}/${repository}/-/commit/${oid}",
            tree = "https://git.procurios.net/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads",
        },
    },
})
