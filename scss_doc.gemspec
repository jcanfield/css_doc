spec = Gem::Specification.new do |s|
  s.name          = 'scss_doc'
  s.version       = '0.0.1'
  s.summary       = "Documentation generator for SCSS files, similar to CSSDOC, Javadoc or RDoc."
  s.description   = %{Library and Executable that extracts documentation from SCSS files.}
  s.files         = ["src/scss_doc/comment_node.rb", "src/scss_doc/document.rb", "src/scss_doc/document_collection.rb", "src/scss_doc/documentation.rb", "src/scss_doc/driver.rb", "src/scss_doc/rule_node.rb", "src/scss_doc/template.rb", "src/scss_doc/variable_node.rb", "src/scss_doc.rb", "src/templates/default/css_doc.css", "src/templates/default/document.html.erb", "src/templates/default/file_index.html.erb", "src/templates/default/index.html.erb", "src/templates/default/layout.html.erb", "src/templates/default/section_index.html.erb", "src/templates/default/selector_index.html.erb", "src/templates/default/variable_index.html.erb"]
  s.date          = "2011-01-10"
  s.require_path  = 'src'
  s.bindir        = 'bin'
  s.executables   = ["scssdoc"]
  s.author        = "Robert Dougan"
  s.email         = "rdougan@me.com"
  s.homepage      = "http://rwd.me"
end
