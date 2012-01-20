class RedClothParslet::Transform < Parslet::Transform
  
  rule(:s => simple(:s)) { String(s) }
  rule(:caps => simple(:s)) { RedClothParslet::Ast::Caps.new(String(s)) }
  rule(:content => subtree(:c)) {|dict| {:content => dict[:c], :opts => {}} }
  rule(:content => subtree(:c), :attributes => subtree(:a)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])} }
  rule(:content => subtree(:c), :attributes => subtree(:a), :href => simple(:h)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:href => dict[:h]}))} }
  rule(:attributes => subtree(:a), :src => simple(:s)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s]}))} }
  rule(:attributes => subtree(:a), :src => simple(:s), :alt => simple(:alt)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt]}))} }
  rule(:attributes => subtree(:a), :src => subtree(:s), :href => simple(:h)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt], :href => dict[:h]}))} }
  
  rule(:layout => simple(:l), :attributes => subtree(:a), :content => subtree(:c)) {|dict|
    {:layout => dict[:l], :content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])}
  }
  
  rule(:extended => subtree(:ext)) { ext[:successive].unshift(ext[:first]) }
  RedClothParslet::Parser::Block::SIMPLE_BLOCK_ELEMENTS.each do |block_type|
    rule(block_type => subtree(:a)) do
      RedClothParslet::Ast::const_get(block_type.capitalize).new(a[:content], a[:opts])
    end
  end
  rule(:notextile => simple(:c)) { RedClothParslet::Ast::Notextile.new(c) }
  rule(:bq => subtree(:a)) { RedClothParslet::Ast::Blockquote.new(a[:content], a[:opts]) }
  rule(:list => subtree(:a)) { RedClothParslet::Ast::List.build(a[:content], a[:opts]) }
  rule(:table => subtree(:a)) { RedClothParslet::Ast::Table.new(a[:content], a[:opts]) }
  rule(:table_row => subtree(:a)) { RedClothParslet::Ast::TableRow.new(a[:content], a[:opts]) }
  rule(:table_data => subtree(:a)) { RedClothParslet::Ast::TableData.new(a[:content], a[:opts]) }
  rule(:table_header => subtree(:a)) { RedClothParslet::Ast::TableHeader.new(a[:content], a[:opts]) }
  
  rule(:em => subtree(:a)) { RedClothParslet::Ast::Em.new(a[:content], a[:opts]) }
  rule(:strong => subtree(:a)) { RedClothParslet::Ast::Strong.new(a[:content], a[:opts]) }
  rule(:bold => subtree(:a)) { RedClothParslet::Ast::B.new(a[:content], a[:opts]) }
  rule(:italics => subtree(:a)) { RedClothParslet::Ast::I.new(a[:content], a[:opts]) }
  rule(:ins => subtree(:a)) { RedClothParslet::Ast::Ins.new(a[:content], a[:opts]) }
  rule(:del => subtree(:a)) { RedClothParslet::Ast::Del.new(a[:content], a[:opts]) }
  rule(:sup => subtree(:a)) { RedClothParslet::Ast::Sup.new(a[:content], a[:opts]) }
  rule(:sub => subtree(:a)) { RedClothParslet::Ast::Sub.new(a[:content], a[:opts]) }
  rule(:span => subtree(:a)) { RedClothParslet::Ast::Span.new(a[:content], a[:opts]) }
  rule(:code => subtree(:a)) { RedClothParslet::Ast::Code.new(a[:content], a[:opts]) }
  rule(:double_quoted_phrase_or_link => subtree(:a)) do
    if a[:opts].has_key?(:href)
      RedClothParslet::Ast::Link.new(a[:content], a[:opts])
    else
      RedClothParslet::Ast::DoubleQuotedPhrase.new(a[:content])
    end
  end
  rule(:image => subtree(:a)) do
    if href = a[:opts].delete(:href)
      RedClothParslet::Ast::Link.new(RedClothParslet::Ast::Img.new([], a[:opts]), {:href => href})
    else
      RedClothParslet::Ast::Img.new([], a[:opts])
    end
  end
  rule(:acronym => subtree(:a)) { RedClothParslet::Ast::Acronym.new(a[:content], a[:opts]) }
  
  rule(:dimension => simple(:d)) { RedClothParslet::Ast::Dimension.new(d) }
  rule(:entity => simple(:e)) { RedClothParslet::Ast::Entity.new(e) }
  rule(:entity => simple(:e), :left => subtree(:l), :left_space => simple(:l_sp), :right => subtree(:r), :right_space => simple(:r_sp)) do
    [l, String(l_sp), RedClothParslet::Ast::Entity.new(e), String(r_sp), r]
  end
end
