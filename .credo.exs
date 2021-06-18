# .credo.exs or config/.credo.exs
%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "tests/"],
        excluded: []
      },
      color: true,
      checks: [
        {Credo.Check.Design.TagFIXME, priority: :low},
        {Credo.Check.Design.TagTODO, priority: :low},
      ]
    }
  ]
}
