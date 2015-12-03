describe "Git grammars", ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-git")

  it "parses the Git config grammar", ->
    grammar = atom.grammars.grammarForScopeName("source.git-config")
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.git-config"

  it "parses the Git commit message grammar", ->
    grammar = atom.grammars.grammarForScopeName("text.git-commit")
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "text.git-commit"

  it "parses the Git rebase message grammar", ->
    grammar = atom.grammars.grammarForScopeName("text.git-rebase")
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "text.git-rebase"
