# Git editing support in Atom
[![macOS Build Status](https://travis-ci.org/atom/language-git.svg?branch=master)](https://travis-ci.org/atom/language-git)
[![Windows Build Status](https://ci.appveyor.com/api/projects/status/481319gyrr1feo8b/branch/master?svg=true)](https://ci.appveyor.com/project/Atom/language-git/branch/master)
[![Dependency Status](https://david-dm.org/atom/language-git.svg)](https://david-dm.org/atom/language-git)

Adds syntax highlighting to Git commit, merge, and rebase messages edited in Atom.

You can configure Atom to be your Git editor with the following command:

```sh
git config --global core.editor "atom --wait"
```

## Commit message highlighting

Violations of [The seven rules of a great git commit message](http://chris.beams.io/posts/git-commit/#seven-rules)
are highlighted as follows:
1. _Not highlighted_: Separate subject from body with a blank line
2. _Overflow highlighted_: Limit the subject line to 50 characters
3. _Initial lowercase letter is highlighted_: Capitalize the subject line
4. _Not highlighted_: Do not end the subject line with a period
5. _Not highlighted_: Use the imperative mood in the subject line
6. _Overflow highlighted_: Wrap the body at 72 characters
7. _Not highlighted_: Use the body to explain what and why vs. how


## Background

Originally [converted](http://flight-manual.atom.io/hacking-atom/sections/converting-from-textmate) from the [Git TextMate bundle](https://github.com/textmate/git.tmbundle).

Contributions are greatly appreciated. Please fork this repository and open a pull request to add snippets, make grammar tweaks, etc.
