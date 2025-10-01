vim.filetype.add({
  filename = {
    [".env"] = "sh",
    [".envrc"] = "sh",
    ["*.env"] = "sh",
    ["*.envrc"] = "sh"
  }
})

vim.filetype.add({
    extension = {
        twig = "twig",
    },
    pattern = {
        [".*%.twig"] = "twig",
        [".*%.html%.twig"] = "html.twig",
    },
})
