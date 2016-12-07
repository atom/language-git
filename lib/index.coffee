{CompositeDisposable} = require 'atom'

module.exports = GitGrammar =
  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add('atom-text-editor', 'language-git:pick': @insertCommand)
    @subscriptions.add atom.commands.add('atom-text-editor', 'language-git:reword': @insertCommand)
    @subscriptions.add atom.commands.add('atom-text-editor', 'language-git:edit': @insertCommand)
    @subscriptions.add atom.commands.add('atom-text-editor', 'language-git:squash': @insertCommand)
    @subscriptions.add atom.commands.add('atom-text-editor', 'language-git:fixup': @insertCommand)
    @subscriptions.add atom.commands.add('atom-text-editor', 'language-git:drop': @insertCommand)

  deactivate: ->
    @subscriptions.dispose()

  insertCommand: (event) ->
    command = /.*:([a-z]+)/.exec(event.type)[1]

    editor = atom.workspace.getActiveTextEditor()

    # Extract the whole current line
    row = editor.getCursorBufferPosition().row
    line = editor.lineTextForBufferRow(row)

    # Extract the hash and the comment from the line
    rebaseLine = /^[a-z]* *([0-9a-f]{7,} .*$)/
    match = rebaseLine.exec(line)
    if not match
      editor.insertText(event.originalEvent.key)
      return
    hashAndComment = match[1]

    # Replace the rebase command
    newLine = "#{command} #{hashAndComment}"
    return if newLine is line
    lineRange = [[row, 0], [row, line.length]]
    editor.setTextInBufferRange(lineRange, newLine)

    # Position the cursor at the beginning of the line to enable a workflow of
    # press-a-command, down, press-a-command, down, ...
    editor.setCursorBufferPosition([row, 0])
