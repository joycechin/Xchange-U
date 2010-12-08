module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = "Xchange-U"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
      image_tag("logo.png", :alt => "XchangeU", :class => "round")
  end
  
  def wrap(description)
    raw(description.split.map{ |s| wrap_long_string(s) }.join(' '))
  end

  def select_tag(name, option_tags = nil, options = {})
    if Array === option_tags
      ActiveSupport::Deprecation.warn 'Not Safe.', caller
    end
    
      html_name = (options[:multiple] == true && !name.to_s.ends_with?("[]")) ? "#{name}[]" : name
        if blank = options.delete(:include_blank)
          if blank.kind_of?(String)
            option_tags = "<option value=\"\">#{blank}</option>".html_safe + option_tags
          else
            option_tags = "<option value=\"\"></option>".html_safe + option_tags
          end
        end
        content_tag :select, option_tags, { "name" => html_name, "id" => sanitize_to_id(name) }.update(options.stringify_keys)
      end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end
  
end
