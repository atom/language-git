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
    hilight = (subject) ->
      {tokens} = grammar.tokenizeLine(subject, null, true)
      returnMe = ''
      for token in tokens
        char = ' '
        for scope in token.scopes
          char = 'd' if scope.match(/deprecated/)
          char = 'i' if scope.match(/illegal/)

        # From: https://coffeescript-cookbook.github.io/chapters/strings/repeating
        returnMe += Array(token.value.length + 1).join(char)

      return returnMe

    beforeEach ->
      grammar = atom.grammars.grammarForScopeName("text.git-commit")

    it "parses the Git commit message grammar", ->
      expect(grammar).toBeTruthy()
      expect(grammar.scopeName).toBe "text.git-commit"

    it "highlights subject lines of less than 50 chars correctly", ->
      expect(
        hilight("123456789012345678901234567890")).
        toEqual("                              ")
      expect(
        hilight("a23456789012345678901234567890")).
        toEqual("i                             ")
      expect(
        hilight("12345678901234567890123456789.")).
        toEqual("                             i")
      expect(
        hilight("b2345678901234567890123456789.")).
        toEqual("i                            i")

    it "highlights subject lines of 50 chars correctly", ->
      expect(
        hilight("12345678901234567890123456789012345678901234567890")).
        toEqual("                                                  ")
      expect(
        hilight("c2345678901234567890123456789012345678901234567890")).
        toEqual("i                                                 ")
      expect(
        hilight("1234567890123456789012345678901234567890123456789.")).
        toEqual("                                                 i")
      expect(
        hilight("d234567890123456789012345678901234567890123456789.")).
        toEqual("i                                                i")

    it "highlights subject lines of 51 chars correctly", ->
      expect(
        hilight("123456789012345678901234567890123456789012345678901")).
        toEqual("                                                  d")
      expect(
        hilight("e23456789012345678901234567890123456789012345678901")).
        toEqual("i                                                 d")
      expect(
        hilight("12345678901234567890123456789012345678901234567890.")).
        toEqual("                                                  i")
      expect(
        hilight("f2345678901234567890123456789012345678901234567890.")).
        toEqual("i                                                 i")

    it "highlights subject lines of 69 chars correctly", ->
      expect(
        hilight("123456789012345678901234567890123456789012345678901234567890123456789")).
        toEqual("                                                  ddddddddddddddddddd")
      expect(
        hilight("g23456789012345678901234567890123456789012345678901234567890123456789")).
        toEqual("i                                                 ddddddddddddddddddd")
      expect(
        hilight("12345678901234567890123456789012345678901234567890123456789012345678.")).
        toEqual("                                                  ddddddddddddddddddi")
      expect(
        hilight("h2345678901234567890123456789012345678901234567890123456789012345678.")).
        toEqual("i                                                 ddddddddddddddddddi")

    it "highlights subject lines of 70 chars correctly", ->
      # 70 chars
      expect(
        hilight("1234567890123456789012345678901234567890123456789012345678901234567890")).
        toEqual("                                                  dddddddddddddddddddi")
      expect(
        hilight("g234567890123456789012345678901234567890123456789012345678901234567890")).
        toEqual("i                                                 dddddddddddddddddddi")
      expect(
        hilight("123456789012345678901234567890123456789012345678901234567890123456789.")).
        toEqual("                                                  dddddddddddddddddddi")
      expect(
        hilight("h23456789012345678901234567890123456789012345678901234567890123456789.")).
        toEqual("i                                                 dddddddddddddddddddi")

    it "highlights subject lines of over 70 chars correctly", ->
      expect(
        hilight("12345678901234567890123456789012345678901234567890123456789012345678901234")).
        toEqual("                                                  dddddddddddddddddddiiiii")
      expect(
        hilight("g2345678901234567890123456789012345678901234567890123456789012345678901234")).
        toEqual("i                                                 dddddddddddddddddddiiiii")
      expect(
        hilight("1234567890123456789012345678901234567890123456789012345678901234567890123.")).
        toEqual("                                                  dddddddddddddddddddiiiii")
      expect(
        hilight("h234567890123456789012345678901234567890123456789012345678901234567890123.")).
        toEqual("i                                                 dddddddddddddddddddiiiii")

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
