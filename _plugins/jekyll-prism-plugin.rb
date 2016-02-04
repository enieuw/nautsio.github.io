# Changed the plugin a bit to make it work with our theme and make it easier for non-techies to use.
# It now does not wrap the block in a div and uses the tag "code" instead of "prism".
# - Erik
module Jekyll

  class PrismBlock < Liquid::Block
    include Liquid::StandardFilters

    OPTIONS_SYNTAX = %r{^([a-zA-Z0-9.+#-]+)((\s+\w+(=[0-9,-]+)?)*)$}

    def initialize(tag_name, markup, tokens)
      super
      if markup.strip =~ OPTIONS_SYNTAX
        @lang = $1
        if defined?($2) && $2 != ''
          tmp_options = {}
          $2.split.each do |opt|
            key, value = opt.split('=')
            if value.nil?
              value = true
            end
            tmp_options[key] = value
          end
          @options = tmp_options
        end
      else
        raise SyntaxError.new("Syntax Error in 'prism' - Valid syntax: prism <lang> [linenos(='1-5')]")
      end
    end

    def render(context)
      code = h(super).strip

      <<-HTML
<pre class='language-#{@lang}'><code>#{code}</code></pre>
      HTML
    end
  end

end

Liquid::Template.register_tag('code', Jekyll::PrismBlock)
