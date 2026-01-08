vim.filetype.add({
	filename = {
		[".env"] = "sh",
		[".envrc"] = "sh",
		["*.env"] = "sh",
		["*.envrc"] = "sh",
	},
})

vim.filetype.add({
	extension = {
		twig = "twig",
	},
	pattern = {
		[".*%.twig"] = "twig",
		[".*%.html%.twig"] = "twig",
	},
})

vim.filetype.add({
	extension = {
		mdc = "mdc",
	},
	pattern = {
		[".*%.mdc"] = "md",
	},
})

-- GLSL shader filetypes
vim.filetype.add({
	extension = {
		glsl = "glsl",
		vert = "glsl",
		frag = "glsl",
		vs = "glsl",
		fs = "glsl",
		comp = "glsl",
		geom = "glsl",
		tesc = "glsl",
		tese = "glsl",
	},
})
