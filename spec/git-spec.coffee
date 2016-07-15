describe "Git grammars", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-git")

  describe "Git configs", ->
    beforeEach ->
      grammar = atom.grammars.grammarForScopeName("source.git-config")

    it "parses the Git config grammar", ->
      expect(grammar).toBeTruthy()
      expect(grammar.scopeName).toBe "source.git-config"

  describe "Git commit messages", ->
    beforeEach ->
      grammar = atom.grammars.grammarForScopeName("text.git-commit")

    it "parses the Git commit message grammar", ->
      expect(grammar).toBeTruthy()
      expect(grammar.scopeName).toBe "text.git-commit"

  describe "Git rebases", ->
    beforeEach ->
      grammar = atom.grammars.grammarForScopeName("text.git-rebase")

    it "parses the Git rebase message grammar", ->
      expect(grammar).toBeTruthy()
      expect(grammar.scopeName).toBe "text.git-rebase"

    for cmd in ["pick", "p", "reword", "r", "edit", "e", "squash", "s", "fixup", "f", "drop", "d"]
      it "parses the #{cmd} command", ->
        {tokens} = grammar.tokenizeLine "#{cmd} c0ffeee This is commit message"

        expect(tokens[0]).toEqual value: cmd, scopes: ["text.git-rebase", "meta.commit-command.git-rebase", "support.function.git-rebase"]
        expect(tokens[1]).toEqual value: " ", scopes: ["text.git-rebase", "meta.commit-command.git-rebase"]
        expect(tokens[2]).toEqual value: "c0ffeee", scopes: ["text.git-rebase", "meta.commit-command.git-rebase", "constant.sha.git-rebase"]
        expect(tokens[3]).toEqual value: " ", scopes: ["text.git-rebase", "meta.commit-command.git-rebase"]
        expect(tokens[4]).toEqual value: "This is commit message", scopes: ["text.git-rebase", "meta.commit-command.git-rebase", "meta.commit-message.git-rebase"]

    it "parses the exec command", ->
      {tokens} = grammar.tokenizeLine "exec"

      expect(tokens[0]).toEqual value: "exec", scopes: ["text.git-rebase", "meta.exec-command.git-rebase", "support.function.git-rebase"]

      {tokens} = grammar.tokenizeLine "x"

      expect(tokens[0]).toEqual value: "x", scopes: ["text.git-rebase", "meta.exec-command.git-rebase", "support.function.git-rebase"]

    it "includes language-shellscript highlighting when using the exec command", ->
      waitsForPromise ->
        atom.packages.activatePackage("language-shellscript")

      runs ->
        {tokens} = grammar.tokenizeLine "exec echo 'Hello World'"

        expect(tokens[0]).toEqual value: "exec", scopes: ["text.git-rebase", "meta.exec-command.git-rebase", "support.function.git-rebase"]
        expect(tokens[1]).toEqual value: " ", scopes: ["text.git-rebase", "meta.exec-command.git-rebase"]
        expect(tokens[2]).toEqual value: "echo", scopes: ["text.git-rebase", "meta.exec-command.git-rebase", "support.function.builtin.shell"]
