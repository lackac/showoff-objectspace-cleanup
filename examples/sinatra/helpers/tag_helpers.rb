helpers do
  def stylesheet_link_tag(source)
    %Q{<link type="text/css" media="screen" rel="stylesheet" href="/stylesheets/#{source}.css?1271182870" />}
  end
  
  def link_to(caption, url)
    %Q{<a href="#{url}">#{caption}</a>}
  end
end