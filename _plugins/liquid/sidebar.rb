module Jekyll
  class SidebarTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      @context = context
      data = @markup.split(" ")
      sidebar_data = @context[data[0].strip][0]
      @version = @context[data[1].strip]
      @page_url = @context[data[2].strip]

      return '' if sidebar_data.nil? or sidebar_data['nested'].nil?

      '<ul class="sidebar-nav">' + build_sidebar_string(sidebar_data['nested']) + '</ul>'
    end

    def build_sidebar_string(sidebar_data)
        sidebar_string = ''
        sidebar_data.each do |nested_item|
            sidebar_item_title = nested_item['title']
            sidebar_item_url = versionize_url(nested_item['url'])
            include_versions = nested_item['include_versions']

            next nested_item unless include_versions.nil? or include_versions.include? @version

            if sidebar_item_url.nil? then
                sidebar_string += <<-EOF
<li>
    <a href="#" class="sidebar-nav__opener">
        <i class="icon-arrow-right"></i>
        <strong class="sidebar-nav__title">#{sidebar_item_title}</strong>
    </a>
EOF
            elsif sidebar_item_url == @page_url then
                sidebar_string += <<-EOF
<li class="active-page-item">
    <a title="#{sidebar_item_title}" href="#{sidebar_item_url}" class="sidebar-nav__link">#{sidebar_item_title}</a>
EOF
            else
                sidebar_string += <<-EOF
<li>
    <a title="#{sidebar_item_title}" href="#{sidebar_item_url}" class="sidebar-nav__link">#{sidebar_item_title}</a>
EOF
            end

            if not nested_item['nested'].nil? then
                sidebar_string += '<ul>' + build_sidebar_string(nested_item['nested']) + '</ul>'
            end
            sidebar_string += '</li>'
        end

        return sidebar_string
    end
    
    def versionize_url(url)
        return url if url == nil or url.empty? or @version == nil or @version.empty?
    
        url.match(%r{\A/docs/(?<product>\w+)/(?<role>\w+)/(?<category>[\w-]+)/});
        product = Regexp.last_match(:product)
        role = Regexp.last_match(:role)
        category = Regexp.last_match(:category)
    
        return url if not shouldBeVersioned(product, role, category)
    
        url_prefix = "/docs/#{product}/#{role}/#{category}/"
        url.clone.insert(url_prefix.length, @version + "/")
    end
    
    def shouldBeVersioned(product, role, category)
        # TODO: add proper SCOS categories later
        return true if product == 'scos'
    
        versioned_categories = @context.registers[:site].config['versioned_categories']
    
        versioned_categories[product] != nil and
            versioned_categories[product][role] != nil and
            versioned_categories[product][role].include? category
    end
  end
end

Liquid::Template.register_tag('render_sidebar', Jekyll::SidebarTag)