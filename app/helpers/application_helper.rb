module ApplicationHelper
  def markdown(text)
    markdown = Redcarpet::Markdown.new(SafeMarkdown,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: false,
      autolink: true,
      strikethrough: true,
      superscript: true,
      quote: true,
      footnotes: true,
      space_after_headers: true,
      underline: true,
      highlight: true,
      tables: true,
      link_attributes: { rel: 'nofollow', target: '_blank' }
    )

    markdown.render(text).html_safe
  end

  def emojify(content)
    h(content).to_str.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias($1)
        %(<img class="emoji" alt="#$1" src="#{image_path("emoji/#{emoji.image_filename}")}" style="vertical-align:middle" width="20" height="20" />)
      else
        match
      end
    end.html_safe if content.present?
  end

  def remove_emoji(content)
    content.gsub(/:[^:]*:/, '')
  end

  def current_controller?(name)
    controller_name == name
  end
end
