local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {
  php = {
    -- Debug snippet
    ls.parser.parse_snippet("debug", "echo json_encode($1, JSON_PRETTY_PRINT);\ndie();"),

    -- Static function snippet with choice for visibility
    s("sfunc", {
      c(1, { t("public"), t("private"), t("protected") }),
      t(" static function "), i(2, "functionName"), t("("), i(3, "parameters"), t({ ") {", "\t" }),
      i(4, "// static function body"), t({ "", "}" })
    }),

    s("foreach", {
      t("foreach ($"), i(1, "array"), t(" as $"), i(2, "key"), t(" => $"), i(3, "value"), t(") {"),
      t({ "", "\t// loop body" }),
      t({ "", "}" })
    }),

    s("__", {
      t("public function __construct("), i(1, "$param"), t(") {"),
      t({ "", "\t$this->param = $param;" }),
      t({ "", "}" })
    }),


    s("commentblock", {
      t("/**"),
      t({ "", " * " }), i(1, "Description"), t({ "", " * " }),
      t({ "", " * @param type $param" }),
      t({ "", " * @return type" }),
      t({ "", " */" })
    }),

    -- Method snippet with choice for visibility
    s("func", {
      c(1, { t("public"), t("private"), t("protected") }),
      t(" function "), i(2, "functionName"), t("("), i(3, "parameters"), t({ ") {", "\t" }),
      i(4, "// method body"), t({ "", "}" })
    }),

    s("php", {
      t("<?php")
    }),

    -- Ternary
    s("ternary", {
      -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
      t("$"), i(1, "cond"), t(" ? $"), i(2, "then"), t(" : $"), i(3, "else")
    }),

    -- AJAX request snippet
    s("ajax", {
      t("$.ajax({"),
      t({ "", "\ttype: \"" }), c(1, { t("POST"), t("GET") }), t("\","),
      t({ "", "\turl: \"" }), i(2, "?"), t("\","),
      t({ "", "\tdata: {", "\t\t" }), i(3, "key1"), t(": "), i(4, "value1"), t(","),
      t({ "", "\t\t" }), i(5, "key2"), t(": "), i(6, "value2"), t(","),
      t({ "", "\t\t" }), i(7, "key3"), t(": "), i(8, "value3"), t({ ",", "\t}," }),
      t({ "", "\tsuccess: function(data) {", "\t\tif(data.success) {", "\t\t\t// Handle success", "\t\t}", "\t}" }),
      t({ "", "});" })
    }),
  },

  go = {
    -- errnil
    s("err", {
      t("if err != nil {"),
      i("$0"),  -- This positions the cursor here
      t("}")
    }),

    -- Function declaration
    s("fn", {
      t("func "), i(1, "name"), t("("), i(2), t(") "), i(3, "returnType"), t(" {"),
      t({"", "\t"}), i(0),
      t({"", "}"})
    }),

    -- Struct definition
    s("struct", {
      t("type "), i(1, "Name"), t(" struct {"),
      t({"", "\t"}), i(0),
      t({"", "}"})
    }),

    -- Interface definition
    s("interface", {
      t("type "), i(1, "Name"), t(" interface {"),
      t({"", "\t"}), i(0),
      t({"", "}"})
    }),
  }
}
