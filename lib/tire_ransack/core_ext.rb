class String
  # http://lucene.apache.org/core/old_versioned_docs/versions/2_9_1/queryparsersyntax.html
  LUCENE_ESCAPE_REGEX = /(\+|-|&&|\|\||!|\(|\)|{|}|\[|\]|\^|"|~|\*|\?|:|\\|\/)/


  def lucene_escape
    self.gsub(LUCENE_ESCAPE_REGEX, "\\\\\\1")
  end
end