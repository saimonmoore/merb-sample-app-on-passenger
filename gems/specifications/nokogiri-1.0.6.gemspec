# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nokogiri}
  s.version = "1.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Patterson", "Mike Dalessio"]
  s.date = %q{2008-11-14}
  s.description = %q{Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser.}
  s.email = ["aaronp@rubyforge.org", "mike.dalessio@gmail.com"]
  s.extensions = ["Rakefile"]
  s.extra_rdoc_files = ["History.ja.txt", "History.txt", "Manifest.txt", "README.ja.txt", "README.txt"]
  s.files = ["History.ja.txt", "History.txt", "Manifest.txt", "README.ja.txt", "README.txt", "Rakefile", "ext/nokogiri/extconf.rb", "ext/nokogiri/html_document.c", "ext/nokogiri/html_document.h", "ext/nokogiri/html_sax_parser.c", "ext/nokogiri/html_sax_parser.h", "ext/nokogiri/native.c", "ext/nokogiri/native.h", "ext/nokogiri/xml_cdata.c", "ext/nokogiri/xml_cdata.h", "ext/nokogiri/xml_document.c", "ext/nokogiri/xml_document.h", "ext/nokogiri/xml_dtd.c", "ext/nokogiri/xml_dtd.h", "ext/nokogiri/xml_io.c", "ext/nokogiri/xml_io.h", "ext/nokogiri/xml_node.c", "ext/nokogiri/xml_node.h", "ext/nokogiri/xml_node_set.c", "ext/nokogiri/xml_node_set.h", "ext/nokogiri/xml_reader.c", "ext/nokogiri/xml_reader.h", "ext/nokogiri/xml_sax_parser.c", "ext/nokogiri/xml_sax_parser.h", "ext/nokogiri/xml_syntax_error.c", "ext/nokogiri/xml_syntax_error.h", "ext/nokogiri/xml_text.c", "ext/nokogiri/xml_text.h", "ext/nokogiri/xml_xpath.c", "ext/nokogiri/xml_xpath.h", "ext/nokogiri/xml_xpath_context.c", "ext/nokogiri/xml_xpath_context.h", "ext/nokogiri/xslt_stylesheet.c", "ext/nokogiri/xslt_stylesheet.h", "lib/nokogiri.rb", "lib/nokogiri/css.rb", "lib/nokogiri/css/generated_parser.rb", "lib/nokogiri/css/generated_tokenizer.rb", "lib/nokogiri/css/node.rb", "lib/nokogiri/css/parser.rb", "lib/nokogiri/css/parser.y", "lib/nokogiri/css/syntax_error.rb", "lib/nokogiri/css/tokenizer.rb", "lib/nokogiri/css/tokenizer.rex", "lib/nokogiri/css/xpath_visitor.rb", "lib/nokogiri/decorators.rb", "lib/nokogiri/decorators/hpricot.rb", "lib/nokogiri/decorators/hpricot/node.rb", "lib/nokogiri/decorators/hpricot/node_set.rb", "lib/nokogiri/decorators/hpricot/xpath_visitor.rb", "lib/nokogiri/hpricot.rb", "lib/nokogiri/html.rb", "lib/nokogiri/html/builder.rb", "lib/nokogiri/html/document.rb", "lib/nokogiri/html/sax/parser.rb", "lib/nokogiri/version.rb", "lib/nokogiri/xml.rb", "lib/nokogiri/xml/after_handler.rb", "lib/nokogiri/xml/before_handler.rb", "lib/nokogiri/xml/builder.rb", "lib/nokogiri/xml/cdata.rb", "lib/nokogiri/xml/document.rb", "lib/nokogiri/xml/dtd.rb", "lib/nokogiri/xml/element.rb", "lib/nokogiri/xml/entity_declaration.rb", "lib/nokogiri/xml/node.rb", "lib/nokogiri/xml/node_set.rb", "lib/nokogiri/xml/notation.rb", "lib/nokogiri/xml/reader.rb", "lib/nokogiri/xml/sax.rb", "lib/nokogiri/xml/sax/document.rb", "lib/nokogiri/xml/sax/parser.rb", "lib/nokogiri/xml/syntax_error.rb", "lib/nokogiri/xml/text.rb", "lib/nokogiri/xml/xpath.rb", "lib/nokogiri/xml/xpath/syntax_error.rb", "lib/nokogiri/xml/xpath_context.rb", "lib/nokogiri/xslt.rb", "lib/nokogiri/xslt/stylesheet.rb", "test/css/test_nthiness.rb", "test/css/test_parser.rb", "test/css/test_tokenizer.rb", "test/css/test_xpath_visitor.rb", "test/files/dont_hurt_em_why.xml", "test/files/staff.xml", "test/files/staff.xslt", "test/files/tlm.html", "test/helper.rb", "test/hpricot/files/basic.xhtml", "test/hpricot/files/boingboing.html", "test/hpricot/files/cy0.html", "test/hpricot/files/immob.html", "test/hpricot/files/pace_application.html", "test/hpricot/files/tenderlove.html", "test/hpricot/files/uswebgen.html", "test/hpricot/files/utf8.html", "test/hpricot/files/week9.html", "test/hpricot/files/why.xml", "test/hpricot/load_files.rb", "test/hpricot/test_alter.rb", "test/hpricot/test_builder.rb", "test/hpricot/test_parser.rb", "test/hpricot/test_paths.rb", "test/hpricot/test_preserved.rb", "test/hpricot/test_xml.rb", "test/html/sax/test_parser.rb", "test/html/test_builder.rb", "test/html/test_document.rb", "test/test_convert_xpath.rb", "test/test_css_cache.rb", "test/test_gc.rb", "test/test_nokogiri.rb", "test/test_reader.rb", "test/test_xslt_transforms.rb", "test/xml/sax/test_parser.rb", "test/xml/test_builder.rb", "test/xml/test_cdata.rb", "test/xml/test_document.rb", "test/xml/test_dtd.rb", "test/xml/test_node.rb", "test/xml/test_node_set.rb", "test/xml/test_text.rb", "vendor/hoe.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://nokogiri.rubyforge.org/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{nokogiri}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser.}
  s.test_files = ["test/css/test_nthiness.rb", "test/css/test_parser.rb", "test/css/test_tokenizer.rb", "test/css/test_xpath_visitor.rb", "test/hpricot/test_alter.rb", "test/hpricot/test_builder.rb", "test/hpricot/test_parser.rb", "test/hpricot/test_paths.rb", "test/hpricot/test_preserved.rb", "test/hpricot/test_xml.rb", "test/html/sax/test_parser.rb", "test/html/test_builder.rb", "test/html/test_document.rb", "test/test_convert_xpath.rb", "test/test_css_cache.rb", "test/test_gc.rb", "test/test_nokogiri.rb", "test/test_reader.rb", "test/test_xslt_transforms.rb", "test/xml/sax/test_parser.rb", "test/xml/test_builder.rb", "test/xml/test_cdata.rb", "test/xml/test_document.rb", "test/xml/test_dtd.rb", "test/xml/test_node.rb", "test/xml/test_node_set.rb", "test/xml/test_text.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
